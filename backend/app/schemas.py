from datetime import date, datetime

from app.constants import DATE_FORMAT, IS_PROD, IS_TEST, TIME_FORMAT, ICONS
from marshmallow import (
    Schema,
    ValidationError,
    fields,
    post_load,
    validate,
    validates_schema,
)


class CustomFields:
    @staticmethod
    def username(required=False):
        return fields.String(
            validate=[
                validate.Length(min=1, max=64),
                validate.ContainsNoneOf([" "], error="username cannot contain spaces."),
            ],
            required=required,
        )

    @staticmethod
    def email(required=False):
        return fields.Email(required=required)

    @staticmethod
    def password(required=False):
        return fields.String(validate=validate.Length(min=8, max=64), required=required)

    @staticmethod
    def fullname(required=False):
        return fields.String(validate=validate.Length(min=1, max=64), required=required)

    @staticmethod
    def courseAbbreviation(required=False):
        return fields.String(
            validate=[validate.Length(min=1, max=8), validate.Regexp(r"[a-zA-Z0-9]*")],
            required=required,
        )

    @staticmethod
    def description(required=False):
        return fields.String(
            validate=validate.Length(min=1, max=1024), required=required
        )

    @staticmethod
    def icon(required=False):
        return fields.String(
            validate=lambda icon: icon[:3] == "bi-" and icon[3:] in ICONS,
            required=required,
        )


class UserSchema(Schema):
    username = CustomFields.username(required=True)
    email = CustomFields.email(required=True)
    password = CustomFields.password(required=True)
    fullname = CustomFields.fullname(required=True)
    bio = CustomFields.description()


class PasswordSchema(Schema):
    password = CustomFields.password(required=True)


class LoginSchema(Schema):
    email = CustomFields.email(required=True)
    password = CustomFields.password(required=True)


class ProfileSchema(Schema):
    oldUsername = CustomFields.username(required=True)
    newUsername = CustomFields.username()
    email = CustomFields.email()
    password = CustomFields.password(required=True)
    bio = CustomFields.description()
    fullname = CustomFields.fullname()


class EmailSchema(Schema):
    email = CustomFields.email()


class CourseSchema(Schema):
    name = fields.String(validate=validate.Length(min=1, max=64), required=True)
    abbreviation = CustomFields.courseAbbreviation(required=True)
    icon = CustomFields.icon(required=True)
    syllabus = CustomFields.description(required=True)
    maxStudents = fields.Integer(
        validate=validate.Range(min=1, error="maxStudents must be greater than 0."),
        required=True,
    )
    address = fields.String(validate=validate.Length(max=256))
    latitude = fields.Float(validate=validate.Range(min=-90, max=90))
    longitude = fields.Float(validate=validate.Range(min=-180, max=180))

    @validates_schema
    def validate_coord_addr(self, data, **kwargs):
        lat = "latitude" in data
        lon = "longitude" in data
        addr = "address" in data
        if (lat or lon or addr) and (not lat or not lon or not addr):
            raise ValidationError(
                "Cannot provide one of latitude, longitude and address without providing the other 2."
            )

    @post_load
    def capitalizeAbbreviation(self, data, **kwargs):
        data["abbreviation"] = data["abbreviation"].upper()
        return data


class UpdateCourseSchema(Schema):
    name = fields.String(validate=validate.Length(min=1, max=64))
    abbreviation = CustomFields.courseAbbreviation()
    icon = CustomFields.icon()
    syllabus = CustomFields.description()
    address = fields.String(validate=validate.Length(min=1, max=256))
    latitude = fields.Float(validate=validate.Range(min=-90, max=90))
    longitude = fields.Float(validate=validate.Range(min=-180, max=180))

    @validates_schema
    def validate_coord_addr(self, data, **kwargs):
        lat = "latitude" in data
        lon = "longitude" in data
        addr = "address" in data
        if (lat or lon or addr) and (not lat or not lon or not addr):
            raise ValidationError(
                "Cannot provide one of latitude, longitude and address without providing the other 2."
            )

    @post_load
    def capitalizeAbbreviation(self, data, **kwargs):
        if "abbreviation" in data:
            data["abbreviation"] = data["abbreviation"].upper()
        return data


class LectureSchema(Schema):
    courseAbbreviation = CustomFields.courseAbbreviation(required=True)
    summary = CustomFields.description(required=True)
    date = fields.Date(
        format=DATE_FORMAT,
        validate=lambda d: (not IS_PROD and not IS_TEST)
        or d >= date.today(),  # don't check for begin date if in dev
        required=True,
    )
    start = fields.Time(format=TIME_FORMAT, required=True)
    end = fields.Time(format=TIME_FORMAT, required=True)

    @validates_schema
    def validate_dates(self, data, **kwargs):
        if data["date"] == date.today():
            if data["start"] < datetime.now().time():
                raise ValidationError("Cannot set a start date in the past.")
        if data["end"] <= data["start"]:
            raise ValidationError("end dateTime must be greater than start dateTime.")

    @post_load
    def capitalizeAbbreviation(self, data, **kwargs):
        data["courseAbbreviation"] = data["courseAbbreviation"].upper()
        return data


class UpdateLectureSchema(Schema):
    summary = CustomFields.description()
    date = fields.Date(format=DATE_FORMAT, validate=lambda d: d >= date.today())
    start = fields.Time(format=TIME_FORMAT)
    end = fields.Time(format=TIME_FORMAT)

    @validates_schema
    def validate_dates(self, data, **kwargs):
        if not data:
            raise ValidationError("At least one field must be provided.")

        # TODO controlli della nuova data rispetto alle date delle altre lecture

        if "date" in data and "start" in data:
            if data["date"] == date.today() and data["start"] < datetime.now().time():
                raise ValidationError("Cannot set a start date in the past.")

        if "start" in data and "end" in data:
            if data["end"] <= data["start"]:
                raise ValidationError(
                    "end dateTime must be greater than start dateTime."
                )


class ReservationSchema(Schema):
    courseAbbreviation = CustomFields.courseAbbreviation(required=True)
    userId = fields.String(validate=validate.Length(16), required=True)

    @post_load
    def capitalizeAbbreviation(self, data, **kwargs):
        data["courseAbbreviation"] = data["courseAbbreviation"].upper()
        return data


class ReviewSchema(Schema):
    rating = fields.Integer(validate=validate.Range(min=0, max=10), required=True)
    review = CustomFields.description(required=True)
