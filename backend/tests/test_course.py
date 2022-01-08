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
            init(client)
        yield client

    postgresql.stop()


def init(client):
    client.post(
        "/api/users/signUp",
        json=dict(
            email="fabio.fontana@mailbox.org",
            username="fabifont",
            password="qwertyuiop",
            fullname="Fabio Fontana",
        ),
    )

    client.post(
        "/api/users/signUp",
        json=dict(
            email="me@rcastellotti.dev",
            username="rcastellotti",
            password="ilovebears",
            fullname="Roberto Castellotti",
        ),
    )


def signIn(client, email="fabio.fontana@mailbox.org", password="qwertyuiop"):
    client.post(
        "/api/users/signIn",
        json=dict(email=email, password=password),
    )


CORRECT_SO_COURSE = dict(
    abbreviation="SO",
    name="Sistemi operativi",
    icon="bi-person-fill",
    syllabus="Ranziamo tutto",
    maxStudents=100,
)


CORRECT_SAW_COURSE = dict(
    abbreviation="SAW",
    name="Sviluppo applicazioni web",
    icon="bi-person-fill",
    syllabus="PHP è mio amico",
    maxStudents=150,
)


def addCourse(client, course=CORRECT_SO_COURSE):
    r = client.post("/api/courses/addCourse", json=course)
    assert r.status_code == 200
    assert b"Course created successfully." in r.data


def testAddCourse(client):
    signIn(client)
    addCourse(client)


def testAddCourseMissingName(client):
    signIn(client)

    r = client.post(
        "/api/courses/addCourse",
        json=dict(
            abbreviation="SO",
            icon="bi-person-fill",
            syllabus="Ranziamo tutto",
            maxStudents=100,
        ),
    )
    assert r.status_code == 422


def testAddCourseMalformedName(client):
    signIn(client)

    r = client.post(
        "/api/courses/addCourse",
        json=dict(
            abbreviation="SO",
            name="Sistemi operativi Sistemi operativi Sistemi operativi Sistemi operativi Sistemi operativi Sistemi operativi Sistemi operativi Sistemi operativi",
            icon="bi-person-fill",
            syllabus="Ranziamo tutto",
            maxStudents=100,
        ),
    )
    assert r.status_code == 422


def testAddCourseMalformedMaxStudents(client):
    signIn(client)

    r = client.post(
        "/api/courses/addCourse",
        json=dict(
            abbreviation="SO",
            name="Sistemi operativi",
            icon="bi-person-fill",
            syllabus="Ranziamo tutto",
            maxStudents=0,
        ),
    )
    assert r.status_code == 422
    assert b"maxStudents must be greater than 0." in r.data


def testAddCourseIncompletePlace(client):
    signIn(client)

    r = client.post(
        "/api/courses/addCourse",
        json=dict(
            abbreviation="SO",
            name="Sistemi operativi",
            icon="bi-person-fill",
            syllabus="Ranziamo tutto",
            maxStudents=100,
            address="Via Dodecaneso Genova",
        ),
    )
    assert r.status_code == 422
    assert (
        b"Cannot provide one of latitude, longitude and address without providing the other 2."
        in r.data
    )


def testGetCourse(client):
    signIn(client)
    addCourse(client, CORRECT_SO_COURSE)

    r = client.get("/api/courses/SO")
    assert r.status_code == 200


def testGetCourseNotFound(client):
    r = client.get("/api/courses/SO")
    assert r.status_code == 404
    assert b"Course not found." in r.data


def testGetCourses(client):
    signIn(client)
    addCourse(client)
    signIn(client, "me@rcastellotti.dev", "ilovebears")
    addCourse(client, CORRECT_SAW_COURSE)

    r = client.get("/api/courses/getCourses")
    assert r.status_code == 200
    data = json.loads(r.data)
    assert len(data["msg"]["courses"]) == 2


def testGetUserCourses(client):
    signIn(client)
    addCourse(client)
    addCourse(client, CORRECT_SAW_COURSE)
    r = client.get("/api/courses/user/fabifont")
    assert r.status_code == 200
    data = json.loads(r.data)
    assert len(data["msg"]["courses"]) == 2


def testGetUserCoursesNotFound(client):
    r = client.get("/api/courses/user/fedfontana")
    assert r.status_code == 404
    assert b"User not found." in r.data


def testUpdateCourse(client):
    signIn(client)
    addCourse(client)
    r = client.put(
        "/api/courses/SO",
        json=dict(
            latitude="34.455667", longitude="10.235673", address="Via Dodecaneso Genova"
        ),
    )
    assert r.status_code == 200
    assert b"Course updated successfully." in r.data


def testUpdateCourseNotFound(client):
    signIn(client)
    r = client.put(
        "/api/courses/SO",
        json=dict(
            latitude="34.455667", longitude="10.235673", address="Via Dodecaneso Genova"
        ),
    )
    assert r.status_code == 404
    assert b"Course not found." in r.data


def testUpdateCourseUnauthorized(client):
    signIn(client)
    addCourse(client)
    signIn(client, "me@rcastellotti.dev", "ilovebears")
    r = client.put(
        "/api/courses/SO",
        json=dict(
            latitude="34.455667", longitude="10.235673", address="Via Dodecaneso Genova"
        ),
    )
    assert r.status_code == 401
    assert b"Cannot edit other user's course." in r.data


def testUpdateCourseIncompletePlace(client):
    signIn(client)
    addCourse(client)
    r = client.put("/api/courses/SO", json=dict(address="Via Dodecaneso Genova"))
    assert r.status_code == 422
    assert (
        b"Cannot provide one of latitude, longitude and address without providing the other 2."
        in r.data
    )


def testUpdateCourseMalformedLatitude(client):
    signIn(client)
    r = client.put(
        "/api/courses/SO",
        json=dict(
            latitude="340.455667",
            longitude="10.235673",
            address="Via Dodecaneso Genova",
        ),
    )
    assert r.status_code == 422
    assert (
        b"Must be greater than or equal to -90 and less than or equal to 90." in r.data
    )


def testDeleteCourse(client):
    signIn(client)
    addCourse(client)
    r = client.delete("/api/courses/SO")
    assert r.status_code == 200
    assert b"Course deleted successfully." in r.data


def testDeleteCourseNotFound(client):
    signIn(client)
    r = client.delete("/api/courses/SO")
    assert r.status_code == 404
    assert b"Course not found." in r.data


def testDeleteCourseUnauthorized(client):
    signIn(client)
    addCourse(client)
    signIn(client, "me@rcastellotti.dev", "ilovebears")
    r = client.delete("api/courses/SO")
    assert r.status_code == 401
    assert b"Cannot delete other user's course." in r.data
