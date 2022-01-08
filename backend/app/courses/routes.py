import re
from app import db
from app.utils import randomColor
from app.courses import bp
from app.models import Course, User
from app.schemas import CourseSchema, UpdateCourseSchema
from app.utils import authRequired, logRequest
from flask import current_app as a
from flask import request


@bp.get("/<string:courseAbbreviation>")
def getCourse(courseAbbreviation):
    course = Course.query.filter(
        Course.isBanned == False,
        Course.isDeleted == False,
        Course.abbreviation == courseAbbreviation,
    ).first_or_404(description="Course not found.")

    courseData = course.dictWithAdditionalData()

    lectures = course.getLectures()
    if lectures:
        courseData["lectures"] = lectures
    return {"msg": {"course": courseData}}, 200


@bp.get("/getCourses")
def getCourses():
    page = int(request.args.get("page") or 1)

    pagination = Course.query.filter(
        Course.isBanned == False, Course.isDeleted == False
    ).paginate(page, 20, False)

    courses = [course.dictWithAdditionalData() for course in pagination.items]

    return {"msg": {"courses": courses, "pages": pagination.pages}}, 200


@bp.post("/addCourse")
@logRequest
@authRequired
def addCourse(session):
    r = request.get_json()
    schema = CourseSchema().load(dict(r))

    newCourse = Course.fromSchemaAndTeacherIdAndColor(
        schema, session.userId, randomColor()
    )

    db.session.add(newCourse)
    db.session.commit()
    return {"msg": "Course created successfully.", "course": newCourse.as_dict()}, 200


@bp.get("/user/<string:username>")
def getUserCourses(username):
    page = int(request.args.get("page") or 1)

    user = User.query.filter(
        User.isActive == True,
        User.isBanned == False,
        User.isDeleted == False,
        User.username == username,
    ).first_or_404(description="User not found.")

    teacherInfo = {"username": user.username, "fullname": user.fullname}

    pagination = Course.query.filter(
        Course.isBanned == False,
        Course.isDeleted == False,
        Course.teacherId == user.id,
    ).paginate(page, 20, False)

    courses = pagination.items

    coursesList = [
        course.dictWithAdditionalData(teacher=teacherInfo) for course in courses
    ]
    return {"msg": {"courses": coursesList, "pages": pagination.pages}}, 200


@bp.put("/<string:oldAbbreviation>")
@logRequest
@authRequired
def updateCourse(session, oldAbbreviation):
    # oldAbbreviation is the old course abbreviation, schema["abbreviation"] is the new requested abbreviation for the course
    r = request.get_json()
    schema = UpdateCourseSchema().load(dict(r))

    oldAbbreviation = oldAbbreviation.upper()

    course = Course.query.filter(
        Course.isBanned == False,
        Course.isDeleted == False,
        Course.abbreviation == oldAbbreviation,
    ).first_or_404(description="Course not found.")

    if session.userId != course.teacherId and not session.user.isAdmin:
        a.logger.error(
            f"User with id {session.userId} tried updating the course {oldAbbreviation}"
        )
        return {"msg": "Cannot edit other user's course."}, 401

    course.updateWithNewData(schema)

    db.session.commit()
    return {"msg": "Course updated successfully.", "course": course.as_dict()}, 200


@bp.delete("/<string:courseAbbreviation>")
@authRequired
def deleteCourse(session, courseAbbreviation):
    course = Course.query.filter(
        Course.isBanned == False,
        Course.isDeleted == False,
        Course.abbreviation == courseAbbreviation.upper(),
    ).first_or_404(description="Course not found.")

    if session.userId != course.teacherId and not session.user.isAdmin:
        a.logger.error(
            f"User with id {session.userId} tried deletng the course {courseAbbreviation}"
        )
        return {"msg": "Cannot delete other user's course."}, 401

    course.isDeleted = True
    course.deleteAll()
    db.session.commit()
    return {"msg": "Course deleted successfully."}, 200
