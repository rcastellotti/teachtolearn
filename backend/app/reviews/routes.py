from datetime import date, datetime

from app import db
from app.models import Course, Lecture, Reservation, Review, User
from app.reviews import bp
from app.schemas import ReviewSchema
from app.utils import authRequired, generateNanoid
from flask import current_app as a
from flask import request


@bp.post("/addReview/<string:courseAbbreviation>")
@authRequired
def addReview(session, courseAbbreviation):
    r = request.get_json()
    schema = ReviewSchema().load(dict(r))

    courseAbbreviation = courseAbbreviation.upper()

    # Check that the user is enrolled in the course
    # This also checks that the current user isn't the teacher of the course since a teacher can't enroll in his own courses
    Reservation.query.filter(
        Reservation.courseAbbreviation == courseAbbreviation,
        Reservation.userId == session.userId,
    ).first_or_404(
        description="User is not enrolled in the course or is the teacher of it."
    )

    lecture = (
        Lecture.query.filter(
            Lecture.courseAbbreviation == courseAbbreviation, Lecture.isBanned == False
        )
        .order_by(Lecture.index.asc())
        .first()
    )

    # Enrolled students cannot write a review of a course if the course hasn't started yet
    if (
        lecture is None
        or lecture.date > date.today()
        or (lecture.date == date.today() and lecture.end < datetime.now().time())
    ):
        return {"msg": "Cannot add a review to a course that hasn't started yet."}, 400

    newReview = Review(
        reviewer=session.user.id,
        reviewee=courseAbbreviation,
        rating=schema["rating"],
        review=schema["review"],
        id=generateNanoid(),
    )

    db.session.add(newReview)
    db.session.commit()
    return {
        "msg": "Review created successfully.",
        "review": newReview.as_dict(
            reviewer={
                "fullname": session.user.fullname,
                "username": session.user.username,
            }
        ),
    }, 200


@bp.delete("<string:reviewId>")
@authRequired
def deleteReview(session, reviewId):
    review = Review.query.filter(Review.id == reviewId).first_or_404(
        description="Review not found."
    )

    if session.user.id != review.reviewer and not session.user.isAdmin:
        a.logger.error(
            f"User with id {session.userId} tried to delete {review.reviewer}' review on {review.reviewee}"
        )
        return {"msg": "Cannot delete other user's review."}, 401

    db.session.delete(review)
    db.session.commit()
    return {"msg": "Review deleted successfully."}, 200


@bp.get("/<string:courseAbbreviation>")
def getReviews(courseAbbreviation):
    courseAbbreviation = courseAbbreviation.upper()

    Course.query.filter(
        Course.abbreviation == courseAbbreviation,
        Course.isBanned == False,
        Course.isDeleted == False,
    ).first_or_404(description="Course not found.")

    reviews = (
        Review.query.filter(
            Review.isBanned == False,
            Review.reviewee == courseAbbreviation,
        )
        .join(User, User.id == Review.reviewer)
        .add_columns(User.username, User.isDeleted, User.fullname)
        .all()
    )

    def as_dict(row):
        review, username, userIsDeleted, fullname = row
        username = username if not userIsDeleted else "[deleted user]"
        fullname = fullname if not userIsDeleted else "[deleted user]"
        return review.as_dict(reviewer={"username": username, "fullname": fullname})

    return {
        "msg": {
            "reviews": [as_dict(review) for review in reviews],
        }
    }, 200
