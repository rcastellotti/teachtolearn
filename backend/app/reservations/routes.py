from app import db
from app.models import Course, Reservation, User
from app.reservations import bp
from app.utils import authRequired, generateNanoid
from flask import current_app as a
from flask import request


@bp.get("")
@authRequired
def getUserReservations(session):
    """retruna lista di corsi ai quali l'user corrente e' iscritto"""
    page = int(request.args.get("page") or 1)

    pagination = (
        Course.query.join(
            Reservation, Reservation.courseAbbreviation == Course.abbreviation
        )
        .filter(
            Course.isBanned == False,
            Course.isDeleted == False,
            Reservation.userId == session.userId,
        )
        .add_columns(Reservation.id)
        .paginate(page, 20, False)
    )

    courses = [
        item[0].dictWithAdditionalData(reservationId=item[1])
        for item in pagination.items
    ]

    return {"msg": {"courses": courses, "pages": pagination.pages}}, 200


@bp.get("/<string:courseAbbreviation>/state")
@authRequired
def getUserReservationsState(session, courseAbbreviation):
    """returns false if the current user has not enrolled in the course, true and the reservation id otherwise"""

    reservation = Reservation.query.filter(
        Reservation.courseAbbreviation == courseAbbreviation.upper(),
        Reservation.userId == session.user.id,
    ).first()

    _dict = {
        "msg": {
            "status": reservation is not None,
        }
    }
    if reservation:
        _dict["msg"]["reservation"] = reservation.as_dict()

    return _dict, 200


@bp.post("/<string:courseAbbreviation>")
@authRequired
def addReservation(session, courseAbbreviation):
    courseAbbreviation = courseAbbreviation.upper()

    course = Course.query.filter(
        Course.isBanned == False,
        Course.isDeleted == False,
        Course.abbreviation == courseAbbreviation,
    ).first_or_404(description="Course not found.")

    if session.userId == course.teacherId:
        a.logger.error(
            f"User with id {session.userId} tried enrolling in his own course {courseAbbreviation}"
        )
        return {"msg": "Cannot enroll in your course."}, 400

    if course.enrolledStudents == course.maxStudents:
        a.logger.error(
            f"User with id {session.userId} tried adding a reservation for the course {courseAbbreviation} which is full"
        )
        return {"msg": "No more spots available for this course."}, 400

    newReservation = Reservation(
        userId=session.userId,
        courseAbbreviation=courseAbbreviation,
        id=generateNanoid(),
    )

    db.session.add(newReservation)
    course.enrolledStudents += 1
    db.session.commit()
    return {
        "msg": "Reservation created successfully.",
        "reservation": newReservation.as_dict(),
    }, 200


@bp.delete("/<string:reservationId>")
@authRequired
def deleteReservation(session, reservationId):
    reservation = Reservation.query.filter(
        Reservation.id == reservationId
    ).first_or_404(description="Reservation not found.")

    course = Course.query.filter(
        Course.isBanned == False,
        Course.isDeleted == False,
        Course.abbreviation == reservation.courseAbbreviation,
    ).first_or_404(description="Course not found.")

    if (
        session.userId != reservation.userId
        and course.teacherId != session.userId
        and not session.user.isAdmin
    ):
        a.logger.error(
            f"User with id {session.userId} tried to delete a reservation for the couse {reservation.courseAbbreviation} for the user with id {reservation.userId}"
        )
        return {"msg": "Cannot delete other user's reservation."}, 401

    course.enrolledStudents -= 1
    db.session.delete(reservation)
    db.session.commit()
    return {"msg": "Reservation deleted successfully."}, 200


@bp.get("/<string:courseAbbreviation>")
@authRequired
def getReservations(session, courseAbbreviation):
    page = int(request.args.get("page") or 1)

    course = Course.query.filter(
        Course.isBanned == False,
        Course.isDeleted == False,
        Course.abbreviation == courseAbbreviation.upper(),
    ).first_or_404(description="Course not found.")

    if session.userId != course.teacherId:
        a.logger.error(
            f"User with id {session.userId} tried to get a reservation for the couse {courseAbbreviation}"
        )
        return {"msg": "Cannot get other user's reservations."}, 401

    reservations = (
        Reservation.query.filter(
            Reservation.courseAbbreviation == courseAbbreviation.upper()
        )
        .join(User, User.id == Reservation.userId)
        .add_columns(User.username, User.fullname)
        .all()
    )

    def as_dict(row):
        reservation, username, fullname = row
        return {"username": username, "id": reservation.id, "fullname": fullname}

    return {"msg": {"reservations": [as_dict(row) for row in reservations]}}, 200
