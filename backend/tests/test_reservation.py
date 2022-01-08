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
                "SECRET_KEY": "you-will-never-guess",  # required for sessions,
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


def signIn(client, email="fabio.fontana@mailbox.org", password="qwertyuiop"):
    client.post(
        "/api/users/signIn",
        json=dict(email=email, password=password),
    )


def signOut(client):
    client.post("/api/users/logout")


CORRECT_SO_COURSE = dict(
    abbreviation="SO",
    name="Sistemi operativi",
    icon="bi-person-fill",
    syllabus="Ranziamo tutto",
    maxStudents=100,
)


def addCourse(client, course=CORRECT_SO_COURSE):
    r = client.post("/api/courses/addCourse", json=course)
    assert r.status_code == 200


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

    client.post(
        "/api/users/signUp",
        json=dict(
            email="federico.fontana2000@gmail.com",
            username="fedfontana",
            password="ilovecats",
            fullname="Federico Fontana",
        ),
    )

    signIn(client)
    addCourse(client)
    signOut(client)


def addReservation(client, courseAbbreviation="SO"):
    r = client.post(f"/api/reservations/{courseAbbreviation}")
    assert r.status_code == 200
    assert b"Reservation created successfully." in r.data


def testAddReservation(client):
    signIn(client, "me@rcastellotti.dev", "ilovebears")
    addReservation(client)


def testAddReservationNotFound(client):
    signIn(client)
    r = client.post("/api/reservations/SAW")
    assert r.status_code == 404
    assert b"Course not found." in r.data


def testAddReservationSelfEnrollment(client):
    signIn(client)
    r = client.post("/api/reservations/SO")
    assert r.status_code == 400
    assert b"Cannot enroll in your course." in r.data


def testAddReservationFullCourse(client):
    signIn(client)
    addCourse(
        client,
        course=dict(
            abbreviation="TAC",
            name="Teoria degli automi e calcolabilità",
            icon="bi-person-fill",
            syllabus="Automi",
            maxStudents=1,
        ),
    )
    signIn(client, "me@rcastellotti.dev", "ilovebears")
    addReservation(client, "TAC")
    signIn(client, "federico.fontana2000@gmail.com", "ilovecats")
    r = client.post("/api/reservations/TAC")
    assert r.status_code == 400
    assert b"No more spots available for this course." in r.data


def testGetUserReservations(client):
    signIn(client, "me@rcastellotti.dev", "ilovebears")
    addReservation(client)

    r = client.get("/api/reservations")
    assert r.status_code == 200
    data = json.loads(r.data)
    assert len(data["msg"]["courses"]) == 1


def testGetReservations(client):
    signIn(client, "me@rcastellotti.dev", "ilovebears")
    addReservation(client)
    signIn(client, "federico.fontana2000@gmail.com", "ilovecats")
    addReservation(client)
    signIn(client)

    r = client.get("/api/reservations/SO")
    assert r.status_code == 200
    data = json.loads(r.data)
    assert len(data["msg"]["reservations"]) == 2


def testGetReservationsNotFound(client):
    signIn(client)
    r = client.get("/api/reservations/SAW")
    assert r.status_code == 404
    assert b"Course not found." in r.data


def testGetReservationsUnauthorized(client):
    signIn(client, "me@rcastellotti.dev", "ilovebears")
    r = client.get("/api/reservations/SO")
    assert r.status_code == 401
    assert b"Cannot get other user's reservations." in r.data


def testDeleteReservation(client):
    signIn(client, "me@rcastellotti.dev", "ilovebears")
    addReservation(client)

    r = client.get("/api/reservations")
    assert r.status_code == 200
    data = json.loads(r.data)
    assert len(data["msg"]["courses"]) == 1

    r = client.delete(f"/api/reservations/{data['msg']['courses'][0]['reservationId']}")
    assert r.status_code == 200
    assert b"Reservation deleted successfully." in r.data


def testDeleteReservationNotFound(client):
    signIn(client, "me@rcastellotti.dev", "ilovebears")
    r = client.delete("/api/reservations/abc123")
    assert r.status_code == 404
    assert b"Reservation not found." in r.data


def testDeleteReservationCourseNotFound(client):
    signIn(client, "me@rcastellotti.dev", "ilovebears")
    addReservation(client)

    r = client.get("/api/reservations")
    assert r.status_code == 200
    data = json.loads(r.data)
    assert len(data["msg"]["courses"]) == 1

    from app.models import Course

    Course.query.filter(Course.abbreviation == "SO").update({"isBanned": True})
    db.session.commit()

    r = client.delete(f"/api/reservations/{data['msg']['courses'][0]['reservationId']}")
    assert r.status_code == 404
    assert b"Course not found." in r.data


def testDeleteReservationUnauthorized(client):
    signIn(client, "me@rcastellotti.dev", "ilovebears")
    addReservation(client)

    r = client.get("/api/reservations")
    assert r.status_code == 200
    data = json.loads(r.data)
    assert len(data["msg"]["courses"]) == 1

    signIn(client, "federico.fontana2000@gmail.com", "ilovecats")

    r = client.delete(f"/api/reservations/{data['msg']['courses'][0]['reservationId']}")
    assert r.status_code == 401
    assert b"Cannot delete other user's reservation." in r.data


def testGetUserReservationsStateTrue(client):
    signIn(client, "me@rcastellotti.dev", "ilovebears")
    addReservation(client)

    r = client.get("/api/reservations/SO/state")
    assert r.status_code == 200
    data = json.loads(r.data)
    assert data["msg"]["status"] == True


def testGetUserReservationsStateFalse(client):
    signIn(client, "me@rcastellotti.dev", "ilovebears")

    r = client.get("/api/reservations/SO/state")
    assert r.status_code == 200
    data = json.loads(r.data)
    assert data["msg"]["status"] == False