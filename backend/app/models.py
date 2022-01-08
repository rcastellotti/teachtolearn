from datetime import datetime

from app import db
from app.constants import DATE_FORMAT, DATETIME_FORMAT, TIME_FORMAT
from sqlalchemy.sql import func
from werkzeug.security import check_password_hash, generate_password_hash


class User(db.Model):
    __tablename__ = "users"
    id = db.Column(db.String(16), primary_key=True)
    username = db.Column(db.String(64), index=True, unique=True, nullable=False)
    email = db.Column(db.String(120), index=True, unique=True, nullable=False)
    passwordHash = db.Column(db.String(128))
    bio = db.Column(db.String(1024))
    fullname = db.Column(db.String(64), nullable=False)
    isActive = db.Column(db.Boolean, default=False, nullable=False)
    isAdmin = db.Column(db.Boolean, default=False, nullable=False)
    isBanned = db.Column(db.Boolean, default=False, nullable=False)
    isDeleted = db.Column(db.Boolean, default=False, nullable=False)
    courses = db.relationship("Course", back_populates="teacher")

    def __repr__(self):
        return "<User {}>".format(self.username)

    def as_dict(self):
        return {
            c.name: getattr(self, c.name)
            for c in self.__table__.columns
            if getattr(self, c.name) is not None
        }

    def profile(self):
        _dict = {
            "username": self.username,
            "fullname": self.fullname,
            "email": self.email,
            "isAdmin": self.isAdmin,
        }
        if self.bio != "":
            _dict["bio"] = self.bio
        return _dict

    def public_profile(self):
        _dict = {
            "username": self.username,
            "fullname": self.fullname,
            "isAdmin": self.isAdmin,
            "email": self.email,
        }
        if self.bio != "":
            _dict["bio"] = self.bio
        return _dict

    def setPassword(self, password):
        self.passwordHash = generate_password_hash(password)

    def checkPassword(self, password):
        return check_password_hash(self.passwordHash, password)

    def deleteAll(self):
        for course in self.courses:
            course.isDeleted = True
            course.deleteAll()

        # not deleting user's reviews by choice: they will be returned with username = "[deleted user]"

        Reservation.query.filter(Reservation.userId == self.id).delete()

        for session in self.sessions:
            db.session.delete(session)

    def banAll(self):
        for review in Review.query.filter(
            Review.reviewer == self.username, Review.isBanned == False
        ).all():
            review.isBanned = True

        Reservation.query.filter(Reservation.userId == self.id).delete()

        for course in self.courses:
            course.isBanned = True
            course.banAllLectures()
            course.deleteAllReservations()

    def unbanAll(self):
        for review in Review.query.filter(
            Review.reviewer == self.username, Review.isBanned == True
        ).all():
            review.isBanned = False

        for course in self.courses:
            course.isBanned = False
            course.unbanAllLectures()


class Course(db.Model):
    __tablename__ = "courses"
    abbreviation = db.Column(db.String(8), primary_key=True, index=True)
    name = db.Column(db.String(64), nullable=False)
    icon = db.Column(db.String(32), nullable=False)
    color = db.Column(db.String(16), nullable=False)
    latitude = db.Column(db.Float)
    longitude = db.Column(db.Float)
    address = db.Column(db.String(256))
    syllabus = db.Column(db.String(1024), nullable=False)
    maxStudents = db.Column(db.Integer, nullable=False)
    enrolledStudents = db.Column(db.Integer, nullable=False)
    teacher = db.relationship("User", back_populates="courses")
    teacherId = db.Column(
        db.String(16),
        db.ForeignKey(User.id, ondelete="cascade", onupdate="cascade"),
        nullable=False,
    )
    isBanned = db.Column(db.Boolean, default=False, nullable=False)
    isDeleted = db.Column(db.Boolean, default=False, nullable=False)
    lectures = db.relationship("Lecture", back_populates="course")

    def __repr__(self):
        return "<Course {} with abbr {}>".format(self.name, self.abbreviation)

    def as_dict(self):
        return {
            c.name: getattr(self, c.name)
            for c in self.__table__.columns
            if getattr(self, c.name) is not None
        }

    @staticmethod
    def fromSchemaAndTeacherIdAndColor(schema, teacherId, color):
        return Course(
            name=schema["name"],
            abbreviation=schema["abbreviation"],
            color=color,
            icon=schema["icon"],
            syllabus=schema["syllabus"],
            maxStudents=schema["maxStudents"],
            enrolledStudents=0,
            teacherId=teacherId,
            address=schema["address"] if "address" in schema else None,
            latitude=schema["latitude"] if "latitude" in schema else None,
            longitude=schema["longitude"] if "longitude" in schema else None,
        )

    def dictWithAdditionalData(self, teacher=None, reservationId=None):
        """
        expects teacher to be {"fullname": teacher.fullname, "username": teacher.fullname}

        if they arent provided, the function will query the db to get them
        the function doesn't check the structure of its arguments
        """
        _dict = self.as_dict()
        if teacher is None:
            teacher = {
                "username": self.teacher.username,
                "fullname": self.teacher.fullname,
            }

        del _dict["teacherId"]
        _dict["teacher"] = teacher

        # self.reviewAvg is none if there are no reviews on this course
        reviewAvg = self.reviewAvg
        if reviewAvg:
            _dict["reviewAvg"] = reviewAvg

        beginDate = self.beginDate
        if beginDate:
            _dict["beginDate"] = beginDate.strftime(DATE_FORMAT)

        if reservationId:
            _dict["reservationId"] = reservationId

        return _dict

    def deleteAllLectures(self):
        Lecture.query.filter(Lecture.courseAbbreviation == self.abbreviation).delete()

    def deleteAllReviews(self):
        Review.query.filter(Review.reviewee == self.abbreviation).delete()

    def deleteAllReservations(self):
        Reservation.query.filter(
            Reservation.courseAbbreviation == self.abbreviation
        ).delete()

    def deleteAll(self):
        self.deleteAllLectures()
        self.deleteAllReviews()
        self.deleteAllReservations()

    def banAllLectures(self):
        Lecture.query.filter(
            Lecture.courseAbbreviation == self.abbreviation, Lecture.isBanned == False
        ).update({"isBanned": True})

    def unbanAllLectures(self):
        Lecture.query.filter(
            Lecture.courseAbbreviation == self.abbreviation, Lecture.isBanned == True
        ).update({"isBanned": False})

    def updateWithNewData(self, data):
        """conditionally updates self data with data, which should be a dict provided by UpdateSchema.load()"""
        if "name" in data:
            self.name = data["name"]
        if "abbreviation" in data:
            self.abbreviation = data["abbreviation"]
        if "icon" in data:
            self.icon = data["icon"]
        if "syllabus" in data:
            self.syllabus = data["syllabus"]
        if "address" in data:
            self.address = data["address"]
        if "latitude" in data:
            self.latitude = data["latitude"]
        if "longitude" in data:
            self.longitude = data["longitude"]

    def getLectures(self):
        lectures = (
            Lecture.query.filter(Lecture.courseAbbreviation == self.abbreviation)
            .order_by(Lecture.date.asc(), Lecture.start.asc())
            .all()
        )
        return [lecture.minimalInfo() for lecture in lectures]

    @property
    def reviewAvg(self):
        reviewAvg = (
            Review.query.with_entities(func.avg(Review.rating))
            .filter(
                Review.isBanned == False,
                Review.reviewee == self.abbreviation,
            )
            .first()
        )
        return None if reviewAvg[0] is None else round(reviewAvg[0], 1)

    @property
    def beginDate(self):
        firstLecture = (
            Lecture.query.filter(
                Lecture.courseAbbreviation == self.abbreviation,
                Lecture.isBanned == False,
            )
            .order_by(Lecture.date.asc())
            .first()
        )
        return None if firstLecture is None else firstLecture.date


class Lecture(db.Model):
    __tablename__ = "lectures"
    index = db.Column(db.Integer, primary_key=True)
    courseAbbreviation = db.Column(
        db.String(8),
        db.ForeignKey(Course.abbreviation, ondelete="cascade", onupdate="cascade"),
        primary_key=True,
        index=True,
    )
    summary = db.Column(db.String(1024), nullable=False)
    date = db.Column(db.Date, nullable=False)
    start = db.Column(db.Time, nullable=False)
    end = db.Column(db.Time, nullable=False)
    isBanned = db.Column(db.Boolean, default=False, nullable=False)
    id = db.Column(db.String(16), unique=True, nullable=False)
    course = db.relationship("Course", back_populates="lectures")

    def as_dict(self, courseColor=None):
        if courseColor is None:
            courseColor = (
                Course.query.filter(Course.abbreviation == self.courseAbbreviation)
                .first()
                .color
            )
        _dict = {c.name: getattr(self, c.name) for c in self.__table__.columns}
        _dict["date"] = _dict["date"].strftime(DATE_FORMAT)
        _dict["start"] = _dict["start"].strftime(TIME_FORMAT)
        _dict["end"] = _dict["end"].strftime(TIME_FORMAT)
        _dict["color"] = courseColor
        return _dict

    def minimalInfo(self):
        _dict = {
            c.name: getattr(self, c.name)
            for c in self.__table__.columns
            if c.name != "courseAbbreviation"
        }
        _dict["date"] = _dict["date"].strftime(DATE_FORMAT)
        _dict["start"] = _dict["start"].strftime(TIME_FORMAT)
        _dict["end"] = _dict["end"].strftime(TIME_FORMAT)

        return _dict


class Session(db.Model):
    __tablename__ = "sessions"
    id = db.Column(db.String(16), primary_key=True)
    userId = db.Column(
        db.String(16),
        db.ForeignKey(User.id, ondelete="cascade", onupdate="cascade"),
        nullable=False,
        index=True,
    )
    user = db.relationship(
        "User", backref=db.backref("sessions", cascade="all", lazy=True)
    )
    sessionToken = db.Column(db.String(36), unique=True, nullable=False)
    platform = db.Column(db.String(64), nullable=False, default="")
    ip = db.Column(db.String(64), nullable=False, default="")
    lastLoginTime = db.Column(
        db.DateTime,
        nullable=False,
        default=datetime.now().strftime(DATETIME_FORMAT),
    )

    def __repr__(self):
        return "<Session {}>".format(self.sessionToken)

    def as_dict(self):
        return {
            "id": self.id,
            "ip": self.ip,
            "platform": self.platform,
            "lastLoginTime": self.lastLoginTime.strftime(DATETIME_FORMAT),
        }


class Reservation(db.Model):
    __tablename__ = "reservations"
    id = db.Column(db.String(16), nullable=False, unique=True)
    courseAbbreviation = db.Column(
        db.String(8),
        db.ForeignKey(Course.abbreviation, ondelete="cascade", onupdate="cascade"),
        primary_key=True,
    )
    userId = db.Column(
        db.String(16),
        db.ForeignKey(User.id, ondelete="cascade", onupdate="cascade"),
        primary_key=True,
        index=True,
    )

    def as_dict(self):
        return {c.name: getattr(self, c.name) for c in self.__table__.columns}


class Review(db.Model):
    __tablename__ = "reviews"
    reviewer = db.Column(
        db.String(16),
        db.ForeignKey(User.id, ondelete="SET NULL", onupdate="cascade"),
        primary_key=True,
    )

    reviewee = db.Column(
        db.String(8),
        db.ForeignKey(Course.abbreviation, ondelete="cascade", onupdate="cascade"),
        primary_key=True,
        index=True,
    )
    rating = db.Column(db.Integer, nullable=False)
    review = db.Column(db.String(1024), nullable=False)
    isBanned = db.Column(db.Boolean, default=False, nullable=False)
    id = db.Column(db.String(16), unique=True, nullable=False)

    def as_dict(self, reviewer=None):
        if reviewer is None:
            reviewer = self.reviewer
        _dict = {
            "reviewer": reviewer,
            "rating": self.rating,
            "review": self.review,
            "id": self.id,
        }
        return _dict
