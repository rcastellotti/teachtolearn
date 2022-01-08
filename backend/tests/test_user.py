import json
import os

import pytest
import testing.postgresql
from app import create_app, db

os.environ["FLASK_ENV"] = "testing"


@pytest.fixture
def client():
    postgresql = testing.postgresql.Postgresql(port=7654)
    app = create_app(
        test_config=(
            {
                "SQLALCHEMY_DATABASE_URI": f"postgresql+pg8000{postgresql.url().split('postgresql')[1]}",
                "TESTING": True,
                "SQLALCHEMY_TRACK_MODIFICATIONS": False,
                "SECRET_KEY": "you-will-never-guess",  # required for sessions
            }
        )
    )

    with app.test_client() as client:
        with app.app_context():
            db.session.remove()
            db.drop_all()
            db.create_all()
        yield client

    postgresql.stop()


CORRECT_FABIFONT_USER = dict(
    email="fabio.fontana@mailbox.org",
    username="fabifont",
    password="qwertyuiop",
    fullname="Fabio Fontana",
)


CORRECT_RCASTELLOTTI_USER = dict(
    email="me@rcastellotti.dev",
    username="rcastellotti",
    password="ilovebears",
    fullname="Roberto Castellotti",
)


def signUp(client, user=CORRECT_FABIFONT_USER):
    r = client.post("/api/users/signUp", json=user)
    assert r.status_code == 200
    assert b"User created successfully, check your email." in r.data


def signIn(client, email="fabio.fontana@mailbox.org", password="qwertyuiop"):
    r = client.post(
        "/api/users/signIn",
        json=dict(email=email, password=password),
    )
    assert r.status_code == 200
    assert "sessionToken" in r.headers["Set-Cookie"]


def testSignUp(client):
    signUp(client)


def testSignUpAlreadyExist(client):
    signUp(client)

    r = client.post(
        "/api/users/signUp",
        json=dict(
            email="fabio.fontana@mailbox.org",
            username="fabifont",
            password="qwertyuiop",
            fullname="Fabio Fontana",
        ),
    )
    assert r.status_code == 409
    assert b"User already exists." in r.data


def testSignIn(client):
    signUp(client)
    signIn(client)


def testSignUpMalformedEmail(client):
    r = client.post(
        "/api/users/signUp",
        json=dict(
            email="@mailbox.org",
            username="fabifont",
            password="qwertyuiop",
            fullname="Fabio Fontana",
        ),
    )
    assert r.status_code == 422
    assert b"Not a valid email address." in r.data


def testSignUpMalformedPassword(client):
    r = client.post(
        "/api/users/signUp",
        json=dict(
            email="fabio.fontana@mailbox.org",
            username="fabifont",
            password="q",
            fullname="Fabio Fontana",
        ),
    )
    assert r.status_code == 422
    assert b"Length must be between 8 and 64." in r.data


def testSignUpMalformedUsername(client):
    r = client.post(
        "/api/users/signUp",
        json=dict(
            email="fabio.fontana@mailbox.org",
            username="fabifontfabifontfabifontfabifontfabifontfabifontfabifontfabifontfabifontfabifontfabifont",
            password="qwertyuiop",
            fullname="Fabio Fontana",
        ),
    )
    assert r.status_code == 422
    assert b"Length must be between 1 and 64." in r.data


def testSignUpMalformedFullname(client):
    r = client.post(
        "/api/users/signUp",
        json=dict(
            email="fabio.fontana@mailbox.org",
            username="fabifont",
            password="qwertyuiop",
            fullname="Fabio Fontana Fabio Fontana Fabio Fontana Fabio Fontana Fabio Fontana Fabio Fontana Fabio Fontana",
        ),
    )
    assert r.status_code == 422
    assert b"Length must be between 1 and 64." in r.data


def testSignInNotFound(client):
    r = client.post(
        "/api/users/signIn",
        json=dict(email="fabio.fontana@mailbox.org", password="qwertyuiop"),
    )
    assert r.status_code == 404
    assert b"Incorrect username or password." in r.data


def testSignInWrongPassword(client):
    signUp(client)

    r = client.post(
        "/api/users/signIn",
        json=dict(email="fabio.fontana@mailbox.org", password="abcdefghi"),
    )
    assert r.status_code == 404
    assert b"Incorrect username or password." in r.data


def testDeleteUser(client):
    signUp(client)

    r = client.post(
        "/api/users/signIn",
        json=dict(email="fabio.fontana@mailbox.org", password="qwertyuiop"),
    )
    assert r.status_code == 200
    assert "sessionToken" in r.headers["Set-Cookie"]

    r = client.delete(
        "/api/users/deleteUser",
        json=dict(password="qwertyuiop"),
    )
    assert r.status_code == 200
    assert b"User deleted successfully.", 200


def testDeleteUserWrongPassword(client):
    signUp(client)
    signIn(client)

    r = client.delete(
        "/api/users/deleteUser",
        json=dict(password="abcdefgh"),
    )
    assert r.status_code == 422
    assert b"Incorrect password." in r.data


def testDeleteUserMissingPassword(client):
    signUp(client)
    signIn(client)

    r = client.delete(
        "/api/users/deleteUser",
        json=dict(),
    )
    assert r.status_code == 422


def testGetProfile(client):
    signUp(client)
    signIn(client)

    r = client.get("/api/users/getProfile")
    assert r.status_code == 200


def testGetPublicProfile(client):
    signUp(client)

    r = client.get("/api/users/getPublicProfile/fabifont")
    assert r.status_code == 200


def testGetPublicProfileNotFound(client):
    r = client.get("/api/users/getPublicProfile/fabifont")
    assert r.status_code == 404
    assert b"User not found." in r.data


def testUpdateProfile(client):
    signUp(client)
    signIn(client)

    r = client.put(
        "/api/users/updateProfile",
        json=dict(oldUsername="fabifont", password="qwertyuiop", bio="Btw I use arch"),
    )
    assert r.status_code == 200
    assert b"Profile updated successfully." in r.data


def testUpdateProfileWrongPassword(client):
    signUp(client)
    signIn(client)

    r = client.put(
        "/api/users/updateProfile",
        json=dict(oldUsername="fabifont", password="abcdefgh", bio="Btw I use arch"),
    )
    assert r.status_code == 422
    assert b"Incorrect password." in r.data


def testUpdateProfileWrongUsername(client):
    signUp(client)
    signIn(client)

    r = client.put(
        "/api/users/updateProfile",
        json=dict(
            oldUsername="rcastellotti", password="ilovebears", bio="I love bears"
        ),
    )
    assert r.status_code == 401
    assert b"Cannot update another user's profile." in r.data


def testUpdateProfileMissingPassword(client):
    signUp(client)
    signIn(client)

    r = client.put(
        "/api/users/updateProfile",
        json=dict(oldUsername="fabifont", bio="Btw I use arch"),
    )
    assert r.status_code == 422


def testGetSessions(client):
    signUp(client)
    signIn(client)

    r = client.get("/api/users/getSessions")
    assert r.status_code == 200
    data = json.loads(r.data)
    assert len(data["msg"]["sessions"]) == 1


def testDeleteSession(client):
    signUp(client)
    signIn(client)

    r = client.get("/api/users/getSessions")
    assert r.status_code == 200
    data = json.loads(r.data)
    assert len(data["msg"]["sessions"]) == 1

    r = client.delete(f"/api/users/session/{data['msg']['sessions'][0]['id']}")
    assert r.status_code == 200


def testDeleteSessionNotFound(client):
    signUp(client)
    signIn(client)

    r = client.get("/api/users/getSessions")
    assert r.status_code == 200
    data = json.loads(r.data)
    assert len(data["msg"]["sessions"]) == 1

    r = client.delete("/api/users/session/asessionwiththatiddoesnotexist")
    assert r.status_code == 404


def testDeleteSessionUnauthorized(client):
    signUp(client)
    signIn(client)

    r = client.get("/api/users/getSessions")
    assert r.status_code == 200
    data = json.loads(r.data)
    assert len(data["msg"]["sessions"]) == 1

    client.set_cookie("/", "sessionToken", "")

    signUp(client, CORRECT_RCASTELLOTTI_USER)
    signIn(client, email="me@rcastellotti.dev", password="ilovebears")

    r = client.delete(f"/api/users/session/{data['msg']['sessions'][0]['id']}")
    assert r.status_code == 401


def testSignOut(client):
    signUp(client)
    signIn(client)

    r = client.delete("/api/users/signOut")
    assert r.status_code == 200
    assert b"Signout successful." in r.data


def testActivate(client):
    signUp(client)

    from app.users.utils import generateToken

    token = generateToken("fabio.fontana@mailbox.org", "activationToken")

    r = client.get(f"/api/users/activate/{token}")
    assert r.status_code == 200
    assert b"User activated successfully." in r.data


def testActivateInvalidToken(client):
    signUp(client)
    r = client.get("/api/users/activate/abc123")
    assert r.status_code == 422
    assert b"Invalid token." in r.data


def testActivateUserNotFound(client):
    from app.users.utils import generateToken

    token = generateToken("user@notfound.ok", "activationToken")

    r = client.get(f"/api/users/activate/{token}")
    assert r.status_code == 404
    assert b"User not found." in r.data


def testGetPasswordResetToken(client):
    signUp(client)
    r = client.post(
        "/api/users/getPasswordResetToken", json=dict(email="fabio.fontana@mailbox.org")
    )
    assert r.status_code == 200
    assert (
        b"If the email is in our database you will receive a password recovery link to your email address."
        in r.data
    )


def testGetPasswordResetTokenUserNotFound(client):
    r = client.post(
        "/api/users/getPasswordResetToken", json=dict(email="user@notfound.ok")
    )
    assert r.status_code == 404
    assert b"User not found." in r.data


def testResetPassword(client):
    signUp(client)
    from app.users.utils import generateToken

    token = generateToken("fabio.fontana@mailbox.org", "activationToken")

    r = client.post(
        f"/api/users/passwordReset/{token}", json=dict(password="thisismynewpassword")
    )
    assert r.status_code == 200
    assert b"Password reset successfully." in r.data


def testResetPasswordInvalidToken(client):
    r = client.post(
        "/api/users/passwordReset/abc123", json=dict(password="thisismynewpassword")
    )
    assert r.status_code == 422
    assert b"Invalid token." in r.data


def testResetPasswordUserNotFound(client):
    from app.users.utils import generateToken

    token = generateToken("user@notfound.ok", "activationToken")

    r = client.post(
        f"/api/users/passwordReset/{token}", json=dict(password="thisismynewpassword")
    )
    assert r.status_code == 404
    assert b"User not found." in r.data
