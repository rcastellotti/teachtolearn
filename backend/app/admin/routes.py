from app import db
from app.admin import bp
from app.admin.utils import adminRoute
from app.constants import DATE_FORMAT, TIME_FORMAT
from app.models import Course, Lecture, Review, Session, User
from flask import request


@bp.get("/getUsers")
@adminRoute
def getUsers():
    page = int(request.args.get("page") or 1)

    pagination = User.query.filter(User.isActive == True).paginate(page, 20, False)

    users = pagination.items

    def as_dict(user):
        return {
            "id": user.id,
            "email": user.email,
            "username": user.username,
            "fullname": user.fullname,
            "isAdmin": user.isAdmin,
            "isBanned": user.isBanned,
            "idDeleted": user.isDeleted,
        }

    return {
        "msg": {"users": [as_dict(user) for user in users], "pages": pagination.pages}
    }, 200


@bp.get("/getCourses")
@adminRoute
def getCourses():
    page = int(request.args.get("page") or 1)

    pagination = Course.query.filter().paginate(page, 20, False)
    courses = pagination.items

    def as_dict(course):
        _dict = {
            "icon": course.icon,
            "color": course.color,
            "abbreviation": course.abbreviation,
            "name": course.name,
            "maxStudents": course.maxStudents,
            "teacher": {
                "fullname": course.teacher.fullname,
                "username": course.teacher.username,
            },
            "isDeleted": course.isDeleted,
            "isBanned": course.isBanned,
        }
        if course.address:
            _dict["address"] = course.address
        return _dict

    return {
        "msg": {
            "courses": [as_dict(course) for course in courses],
            "pages": pagination.pages,
        }
    }, 200


@bp.get("/getLectures")
@adminRoute
def getLectures():
    page = int(request.args.get("page") or 1)

    pagination = Lecture.query.paginate(page, 20, False)
    lectures = pagination.items

    def as_dict(lecture):
        return {
            "index": lecture.index,
            "id": lecture.id,
            "date": lecture.date.strftime(DATE_FORMAT),
            "start": lecture.start.strftime(TIME_FORMAT),
            "end": lecture.end.strftime(TIME_FORMAT),
            "isBanned": lecture.isBanned,
            "courseIcon": lecture.course.icon,
            "courseAbbreviation": lecture.course.abbreviation,
            "courseName": lecture.course.name,
            "courseColor": lecture.course.color,
            "teacher": {
                "username": lecture.course.teacher.username,
                "fullname": lecture.course.teacher.fullname,
            },
        }

    return {
        "msg": {
            "lectures": [as_dict(lecture) for lecture in lectures],
            "pages": pagination.pages,
        }
    }, 200


@bp.get("/getReviews")
@adminRoute
def getReviews():
    page = int(request.args.get("page") or 1)

    pagination = (
        Review.query.join(User, User.id == Review.reviewer)
        .add_columns(User.username, User.fullname)
        .paginate(page, 10, False)
    )
    results = pagination.items

    def as_dict(row):
        review, username, fullname = row
        return {
            "id": review.id,
            "isBanned": review.isBanned,
            "courseAbbreviation": review.reviewee,
            "reviewer": {"username": username, "fullname": fullname},
            "rating": review.rating,
            "review": review.review,
        }

    return {
        "msg": {
            "reviews": [as_dict(row) for row in results],
            "pages": pagination.pages,
        }
    }, 200


@bp.get("/getSessions")
@adminRoute
def getSessions():
    page = int(request.args.get("page") or 1)

    pagination = Session.query.paginate(page, 20, False)
    sessions = pagination.items

    def as_dict(session):
        s = session.as_dict()
        s |= {"email": session.user.email, "username": session.user.username}
        return s

    return {
        "msg": {
            "sessions": [as_dict(session) for session in sessions],
            "pages": pagination.pages,
        }
    }, 200


@bp.delete("/user/<string:userId>")
@adminRoute
def banUser(userId):
    user = User.query.filter(User.id == userId, User.isAdmin == False).first_or_404(
        description="User not found or you are trying to ban an admin."
    )
    user.isBanned = True
    user.banAll()
    db.session.commit()
    return {"msg": "User banned successfully."}, 200


@bp.put("/user/<string:userId>")
@adminRoute
def unbanUser(userId):
    user = User.query.filter(User.id == userId, User.isAdmin == False).first_or_404(
        description="User not found or you are trying to unban an admin."
    )
    user.isBanned = False
    user.unbanAll()
    db.session.commit()
    return {"msg": "User unbanned successfully."}, 200


@bp.delete("/course/<string:courseAbbreviation>")
@adminRoute
def banCourse(courseAbbreviation):
    course = Course.query.filter(
        Course.abbreviation == courseAbbreviation
    ).first_or_404(description="Course not found.")
    course.isBanned = True
    course.banAllLectures()
    course.deleteAllReservations()
    db.session.commit()
    return {"msg": "Course banned successfully."}, 200


@bp.put("/course/<string:courseAbbreviation>")
@adminRoute
def unbanCourse(courseAbbreviation):
    course = Course.query.filter(
        Course.abbreviation == courseAbbreviation
    ).first_or_404(description="Course not found.")
    course.isBanned = False
    course.unbanAllLectures()
    db.session.commit()
    return {"msg": "Course unbanned successfully."}, 200


@bp.delete("/lecture/<string:lectureId>")
@adminRoute
def banLecture(lectureId):
    result = Lecture.query.filter(Lecture.id == lectureId).update({"isBanned": True})
    if result == 0:
        return {"msg": "Lecture not found."}, 404
    db.session.commit()
    return {"msg": "Lecture banned successfully."}, 200


@bp.put("/lecture/<string:lectureId>")
@adminRoute
def unbanLecture(lectureId):
    courseAbbreviation = (
        Course.query.filter(Course.isBanned == False, Course.isDeleted == False)
        .join(Lecture, Lecture.courseAbbreviation == Course.abbreviation)
        .filter(Lecture.id == lectureId)
        .first_or_404(description="Course or lecture not found.")
        .abbreviation
    )

    unbannedLectureCount = Lecture.query.filter(
        Lecture.courseAbbreviation == courseAbbreviation, Lecture.isBanned == False
    ).count()

    if unbannedLectureCount == 20:
        return {
            "msg": "Cannot unban lecture for a course that already has 20 lectures."
        }, 409

    Lecture.query.filter(Lecture.id == lectureId).update({"isBanned": False})

    db.session.commit()
    return {"msg": "Lecture unbanned successfully."}, 200


@bp.delete("/review/<string:reviewId>")
@adminRoute
def banReview(reviewId):
    result = Review.query.filter(Review.id == reviewId).update({"isBanned": True})
    if result == 0:
        return {"msg": "Review not found."}, 404
    db.session.commit()
    return {"msg": "Review banned successfully."}, 200


@bp.put("/review/<string:reviewId>")
@adminRoute
def unbanReview(reviewId):
    result = Review.query.filter(Review.id == reviewId).update({"isBanned": False})
    if result == 0:
        return {"msg": "Review not found."}, 404
    db.session.commit()
    return {"msg": "Review unbanned successfully."}, 200
