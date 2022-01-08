from app.models import Course, User
from app.search import bp
from flask import request


def courseAsDictRealtime(row):
    course, username, fullname = row
    _dict = {
        "abbreviation": course.abbreviation,
        "name": course.name,
    }
    return _dict


def courseAsDict(row):
    course, username, fullname = row
    teacher = {"username": username, "fullname": fullname}

    _dict = course.dictWithAdditionalData(teacher=teacher)
    return _dict


@bp.get("")
def search():
    """accepts query as a query parameter q"""

    q = request.args.get("q") or ""

    if not q.strip():
        return {"msg": "Query must be provided."}, 400

    query = f"%{q.strip()}%"

    users = []

    # ilike() => case insensitive LIKE
    users = User.query.filter(
        User.isActive == True,
        User.isDeleted == False,
        User.isBanned == False,
        User.username.ilike(query) | User.fullname.ilike(query),
    ).all()

    courses = (
        Course.query.filter(
            Course.isDeleted == False,
            Course.isBanned == False,
            Course.abbreviation.ilike(query) | Course.name.ilike(query),
        )
        .join(User, User.id == Course.teacherId)
        .add_columns(User.username, User.fullname)
        .all()
    )

    return {
        "msg": {
            "courses": [courseAsDict(course) for course in courses],
            "users": [user.public_profile() for user in users],
        }
    }, 200


@bp.get("/realtime")
def realtime():
    """accepts query as a query parameter q"""

    q = request.args.get("q") or ""

    if not q.strip():
        return {"msg": "Query must be provided."}, 400

    query = f"%{q.strip()}%"

    users = []

    # ilike() => case insensitive LIKE
    users = (
        User.query.filter(
            User.isActive == True,
            User.isDeleted == False,
            User.isBanned == False,
            User.fullname.ilike(query),
        )
        .limit(5)
        .all()
    )

    courses = (
        Course.query.filter(
            Course.isDeleted == False,
            Course.isBanned == False,
            Course.name.ilike(query),
        )
        .join(User, User.id == Course.teacherId)
        .add_columns(User.username, User.fullname)
        .limit(10)
        .all()
    )

    return {
        "msg": {
            "courses": [courseAsDictRealtime(course) for course in courses],
            "users": [user.public_profile() for user in users],
        }
    }, 200
