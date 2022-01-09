import io
from datetime import timedelta

import jwt
import requests
from app import db, utils
from app.constants import (
    IS_PROD,
    IS_TEST,
    JWT_SECRET,
)
from app.models import Session, User
from app.schemas import (
    EmailSchema,
    LoginSchema,
    PasswordSchema,
    ProfileSchema,
    UserSchema,
)
from app.users import bp
from app.users.utils import generateToken, sendActivationEmail, sendResetPasswordEmail
from app.utils import authRequired, generateNanoid, logRequest
from flask import current_app as a
from flask import jsonify, make_response, request
from sqlalchemy.exc import IntegrityError


@bp.post("/signUp")
@logRequest
def signUp():
    r = request.get_json()
    schema = UserSchema().load(dict(r))

    username = schema["username"]
    email = schema["email"]
    password = schema["password"]
    bio = schema["bio"] if "bio" in schema else None
    fullname = schema["fullname"]

    newUser = User(
        id=generateNanoid(), email=email, username=username, bio=bio, fullname=fullname
    )
    newUser.setPassword(password)

    if not IS_PROD:
        newUser.isActive = True

    try:
        db.session.add(newUser)
        db.session.commit()
    except IntegrityError as err:
        a.logger.exception(err)
        return {"msg": "User already exists."}, 409

    token = generateToken(email, "activationToken")
    if not IS_PROD:
        a.logger.debug("activation token (normally sent by-email): %s", token)
    else:
        sendActivationEmail(email, username, token)

    return {"msg": "User created successfully, check your email."}, 200


@bp.post("/signIn")
@logRequest
def signIn():
    r = request.get_json()
    schema = LoginSchema().load(dict(r))

    email = schema["email"]
    password = schema["password"]

    user = User.query.filter(
        User.isActive == True,
        User.isBanned == False,
        User.isDeleted == False,
        User.email == email,
    ).first_or_404(description="Incorrect username or password.")

    if not user.checkPassword(password):
        return {"msg": "Incorrect username or password."}, 404

    # delete the old session if the user was already logged in
    oldSession = utils.getSession()
    if oldSession is not None:
        db.session.delete(oldSession)

    sessionToken = generateNanoid(36)
    # token is converted to string in order to be able to test using sqlite
    s = Session(
        id=generateNanoid(),
        sessionToken=sessionToken,
        user=user,
        ip=request.remote_addr,
        platform=request.user_agent.platform,
    )
    db.session.add(s)
    db.session.commit()

    userProfile = user.profile()
    userProfile["isAdmin"] = user.isAdmin
    res = make_response(jsonify({"msg": {"profile": userProfile}}))
    if IS_PROD:
        res.set_cookie(
            "sessionToken",
            sessionToken,
            max_age=60 * 60 * 24 * 30,
            secure=True,
            samesite="Strict",
            httponly=True,
        )
    else:
        res.set_cookie(
            "sessionToken", sessionToken, max_age=60 * 60 * 24 * 30, httponly=True
        )

    return res, 200


@bp.delete("/signOut")
@authRequired
def signOut(session):
    db.session.delete(session)
    db.session.commit()

    res = make_response(jsonify({"msg": "Signout successful."}))
    res.set_cookie("sessionToken", "")
    return res, 200


@bp.get("/activate/<token>")
def activate(token):
    try:
        decodedToken = jwt.decode(token, JWT_SECRET, algorithms="HS256")
    except jwt.DecodeError:
        return {"msg": "Invalid token."}, 422

    email = decodedToken["email"]
    result = User.query.filter(
        User.isBanned == False, User.isDeleted == False, User.email == email
    ).update({"isActive": True})
    if result == 0:
        return {"msg": "User not found."}, 404
    db.session.commit()
    return {"msg": "User activated successfully."}, 200


@bp.get("/getSessions")
@authRequired
def getSessions(session):
    sessions = Session.query.filter(Session.userId == session.userId).all()
    sessionList = [sess.as_dict() for sess in sessions]
    return {"msg": {"sessions": sessionList}}, 200


@bp.delete("/session/<string:sessionId>")
@authRequired
def deleteSession(session, sessionId):
    sess = Session.query.filter(
        Session.id == sessionId, Session.userId == session.userId
    ).first_or_404(description="Session not found.")

    db.session.delete(sess)
    db.session.commit()
    return {"msg": "Session deleted successfully."}, 200


@bp.get("getPublicProfile/<string:username>")
def getPublicProfile(username):
    user = User.query.filter(
        User.isActive == True,
        User.isBanned == False,
        User.isDeleted == False,
        User.username == username,
    ).first_or_404(description="User not found.")

    return {"msg": {"profile": user.public_profile()}}, 200


@bp.get("/getProfile")
@authRequired
def getProfile(session):
    message = session.user.profile()
    message["id"] = session.id
    return {"msg": {"profile": message}}, 200


@bp.put("/updateProfile")
@logRequest
@authRequired
def updateProfile(session):
    r = request.get_json()
    schema = ProfileSchema().load(dict(r))

    if session.user.username != schema["oldUsername"]:
        return {"msg": "Cannot update another user's profile."}, 401

    if not session.user.checkPassword(schema["password"]):
        return {"msg": "Incorrect password."}, 422
    if "bio" in schema:
        session.user.bio = schema["bio"]
    if "fullname" in schema:
        session.user.fullname = schema["fullname"]
    if "email" in schema:
        session.user.email = schema["email"]
    if "newUsername" in schema:
        session.user.username = schema["newUsername"]

    db.session.add(session.user)
    db.session.commit()
    return {"msg": "Profile updated successfully."}, 200


@bp.post("/getPasswordResetToken")
@logRequest
def getPasswordResetToken():
    r = request.get_json()
    schema = EmailSchema().load(dict(r))

    email = schema["email"]

    user = User.query.filter(
        User.isBanned == False, User.isDeleted == False, User.email == email
    ).first()

    if user is None:
        return {"msg": "User not found."}, 404

    username = user.username
    token = generateToken(email, type="passwordResetToken")
    if not IS_PROD:
        print(f"password-reset token (normally sent by-email): {token}")
    else:
        sendResetPasswordEmail(email, username, token)

    return {
        "msg": "If the email is in our database you will receive a password recovery link to your email address."
    }, 200


@bp.post("/passwordReset/<token>")
def resetPassword(token):
    try:
        decodedToken = jwt.decode(token, JWT_SECRET, algorithms="HS256")
    except jwt.DecodeError:
        return {"msg": "Invalid token."}, 422

    email = decodedToken["email"]
    user = User.query.filter(
        User.isBanned == False, User.isDeleted == False, User.email == email
    ).first()

    if user is None:
        return {"msg": "User not found."}, 404

    r = request.get_json()
    schema = PasswordSchema().load(dict(r))
    user.setPassword(schema["password"])
    db.session.add(user)
    db.session.commit()

    return {"msg": "Password reset successfully."}, 200


@bp.delete("/deleteUser")
@logRequest
@authRequired
def deleteUser(session):
    r = request.get_json()
    schema = PasswordSchema().load(dict(r))

    if not session.user.checkPassword(schema["password"]):
        return {"msg": "Incorrect password."}, 422

    session.user.isDeleted = True
    session.user.deleteAll()
    db.session.commit()
    res = make_response(jsonify({"msg": "User deleted successfully."}))
    res.set_cookie("sessionToken", "")

    return res, 200
