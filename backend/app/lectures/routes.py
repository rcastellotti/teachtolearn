from datetime import date, datetime

from app import db
from app.constants import DATE_FORMAT, TIME_FORMAT
from app.lectures import bp
from app.models import Course, Lecture, Reservation
from app.schemas import LectureSchema, UpdateLectureSchema
from app.utils import authRequired, generateNanoid, logRequest
from flask import current_app as a
from flask import request


@bp.get("/<string:courseAbbreviation>")
def getLectures(courseAbbreviation):
    course = Course.query.filter(
        Course.isBanned == False,
        Course.isDeleted == False,
        Course.abbreviation == courseAbbreviation,
    ).first_or_404(description="Course not found.")

    lectures = [
        lecture.as_dict(courseColor=course.color)
        for lecture in Lecture.query.filter(
            Lecture.isBanned == False,
            Lecture.courseAbbreviation == courseAbbreviation.upper(),
        )
        .order_by(Lecture.date.asc(), Lecture.start.asc())
        .all()
    ]
    return {"msg": {"lectures": lectures}}, 200


@bp.get("/getNextLectures")
@authRequired
def getNextLectures(session):
    page = int(request.args.get("page") or 1)

    today = date.today()
    timeNow = datetime.now().time()

    pagination = (
        Reservation.query.filter(Reservation.userId == session.userId)
        .join(
            Course, Course.abbreviation == Reservation.courseAbbreviation
        )  # no need to filter Course with isBanned or isDeleted: when they are banned/deleted, all reservations get deleted
        .join(Lecture, Lecture.courseAbbreviation == Course.abbreviation)
        .filter(Lecture.isBanned == False)
        .add_columns(
            Lecture.index,
            Lecture.courseAbbreviation,
            Lecture.summary,
            Lecture.date,
            Lecture.start,
            Lecture.end,
            Lecture.id,
        )
        .filter(
            (Lecture.date > today)
            | ((Lecture.date == today) & (Lecture.start > timeNow))
        )
        .order_by(Lecture.date.asc(), Lecture.start.asc())
        .paginate(page, 20, False)
    )
    lectures = pagination.items

    def as_dict(row):
        (
            _,
            lectureIdx,
            lectureAbbr,
            lectureSummary,
            lectureDate,
            lectureStart,
            lectureEnd,
            lectureId,
        ) = row
        return {
            "courseAbbreviation": lectureAbbr,
            "lectureIndex": lectureIdx,
            "summary": lectureSummary,
            "date": lectureDate.strftime(DATE_FORMAT),
            "start": lectureStart.strftime(TIME_FORMAT),
            "end": lectureEnd.strftime(TIME_FORMAT),
            "id": lectureId,
        }

    lectureList = [as_dict(lecture) for lecture in lectures]
    return {"msg": {"lectures": lectureList, "pages": pagination.pages}}, 200


@bp.post("addLecture")
@logRequest
@authRequired
def addLecture(session):
    r = request.get_json()
    schema = LectureSchema().load(dict(r))

    courseAbbreviation = schema["courseAbbreviation"].upper()

    course = Course.query.filter(
        Course.isBanned == False,
        Course.isDeleted == False,
        Course.abbreviation == courseAbbreviation,
    ).first_or_404(description="Course not found.")

    if course.teacherId != session.userId:
        a.logger.error(
            f"User with id {session.userId} tried adding a lecture to the course {courseAbbreviation}"
        )
        return {"msg": "Cannot add lecture to other user's course."}, 401

    lectureCount = Lecture.query.filter(
        Lecture.isBanned == False,
        Lecture.courseAbbreviation == courseAbbreviation,
    ).count()
    if lectureCount == 20:
        return {"msg": "Limit of 20 lectures per course already reached."}, 400

    lastLecture = (
        Lecture.query.filter(
            Lecture.courseAbbreviation == courseAbbreviation,
        )
        .order_by(Lecture.index.desc())
        .first()
    )

    newLectureIndex = 1
    if lastLecture:
        newLectureIndex = lastLecture.index + 1

        # Check that the new lecture starts after/at the end of the last one, if there is one
        if schema["date"] < lastLecture.date or (
            schema["date"] == lastLecture.date and schema["start"] < lastLecture.end
        ):
            return {"msg": "Lecture must start after the end of the previous one."}, 422

    newLecture = Lecture(
        index=newLectureIndex,
        courseAbbreviation=courseAbbreviation,
        summary=schema["summary"],
        date=schema["date"],
        start=schema["start"],
        end=schema["end"],
        id=generateNanoid(),
    )

    db.session.add(newLecture)
    db.session.commit()
    return {
        "msg": "Lecture created successfully.",
        "lecture": newLecture.as_dict(),
    }, 200


@bp.put("/<string:lectureId>")
@logRequest
@authRequired
def updateLecture(session, lectureId):
    r = request.get_json()
    schema = UpdateLectureSchema().load(dict(r))

    lecture = Lecture.query.filter(
        Lecture.isBanned == False, Lecture.id == lectureId
    ).first_or_404(description="Lecture not found.")

    course = Course.query.filter(
        Course.abbreviation == lecture.courseAbbreviation,
    ).first()  # the lecture exists for sure since the lecture exists

    if session.userId != course.teacherId and not session.user.isAdmin:
        a.logger.error(
            f"User with id {session.userId} tried updating lecture {lecture.index} of {lecture.courseAbbreviation}"
        )
        return {"msg": "Cannot edit other user's lecture."}, 401

    if "start" in schema:
        lecture.start = schema["start"]
    if "end" in schema:
        lecture.end = schema["end"]
    if "summary" in schema:
        lecture.summary = schema["summary"]

    db.session.commit()
    return {"msg": "Lecture updated successfully."}, 200


@bp.delete("/<string:lectureId>")
@authRequired
def deleteLecture(session, lectureId):
    lecture = Lecture.query.filter(
        Lecture.isBanned == False,
        Lecture.id == lectureId,
    ).first_or_404(description="Lecture not found.")

    if session.userId != lecture.course.teacherId and not session.user.isAdmin:
        return {"msg": "Cannot delete other user's lecture."}, 401

    db.session.delete(lecture)
    db.session.commit()
    return {"msg": "Lecture deleted successfully."}, 200
