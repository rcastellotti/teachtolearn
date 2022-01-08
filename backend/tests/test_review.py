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


CORRECT_SO_LECTURE = dict(
    courseAbbreviation="SO",
    summary="Syscall",
    date="2022-03-13",
    start="08:00:00",
    end="10:00:00",
)


def addLecture(client, lecture=CORRECT_SO_LECTURE):
    r = client.post("/api/lectures/addLecture", json=lecture)
    assert r.status_code == 200


def addReservation(client, courseAbbreviation="SO"):
    r = client.post(f"/api/reservations/{courseAbbreviation}")
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
    addCourse(client, CORRECT_SAW_COURSE)
    addLecture(client)
    r = client.get("/api/lectures/SO")
    data = json.loads(r.data)

    from app.models import Lecture

    Lecture.query.filter(Lecture.id == data["msg"]["lectures"][0]["id"]).update(
        {"date": "2020-03-13"}
    )

    signIn(client, "me@rcastellotti.dev", "ilovebears")
    addReservation(client)
    addReservation(client, "SAW")
    db.session.commit()
    signOut(client)


CORRECT_SO_REVIEW = dict(rating=10, review="Ottimo")


def addReview(client, courseAbbreviation="SO", review=CORRECT_SO_REVIEW):
    r = client.post(f"/api/reviews/addReview/{courseAbbreviation}", json=review)
    assert r.status_code == 200
    assert b"Review created successfully", 200


def testAddReview(client):
    signIn(client, "me@rcastellotti.dev", "ilovebears")
    addReview(client)


def testAddReviewReservationNotFound(client):
    signIn(client, "federico.fontana2000@gmail.com", "ilovecats")
    r = client.post(
        "/api/reviews/addReview/SO",
        json=dict(rating=10, review="Ottimo anche se non mi sono iscritto"),
    )
    assert r.status_code == 404
    assert b"User is not enrolled in the course or is the teacher of it." in r.data


def testAddReviewTeacher(client):
    signIn(client)
    r = client.post(
        "/api/reviews/addReview/SO",
        json=dict(rating=10, review="Il mio corso è ottimo"),
    )
    assert r.status_code == 404
    assert b"User is not enrolled in the course or is the teacher of it." in r.data


def testAddReviewCourseNotStarted(client):
    signIn(client, "me@rcastellotti.dev", "ilovebears")
    r = client.post(
        "/api/reviews/addReview/SAW",
        json=dict(rating=10, review="Bello questo corso che deve ancora iniziare"),
    )
    assert r.status_code == 400
    assert b"Cannot add a review to a course that hasn't started yet." in r.data


def testGetReviews(client):
    signIn(client, "me@rcastellotti.dev", "ilovebears")
    addReview(client)
    signOut(client)
    r = client.get("/api/reviews/SO")
    assert r.status_code == 200
    data = json.loads(r.data)
    assert len(data["msg"]["reviews"]) == 1


def testGetReviewsCourseNotFound(client):
    r = client.get("/api/reviews/TAC")
    assert r.status_code == 404
    assert b"Course not found." in r.data


def testDeleteReview(client):
    signIn(client, "me@rcastellotti.dev", "ilovebears")
    addReview(client)

    r = client.get("/api/reviews/SO")
    assert r.status_code == 200
    data = json.loads(r.data)
    assert len(data["msg"]["reviews"]) == 1

    r = client.delete(f"/api/reviews/{data['msg']['reviews'][0]['id']}")
    assert r.status_code == 200
    assert b"Review deleted successfully." in r.data


def testDeleteReviewNotFound(client):
    signIn(client, "me@rcastellotti.dev", "ilovebears")
    r = client.delete("/api/reviews/abc123")
    assert r.status_code == 404
    assert b"Review not found." in r.data


def testDeleteReviewUnauthorized(client):
    signIn(client, "me@rcastellotti.dev", "ilovebears")
    addReview(client)
    signIn(client, "federico.fontana2000@gmail.com", "ilovecats")

    r = client.get("/api/reviews/SO")
    assert r.status_code == 200
    data = json.loads(r.data)
    assert len(data["msg"]["reviews"]) == 1

    r = client.delete(f"/api/reviews/{data['msg']['reviews'][0]['id']}")
    assert r.status_code == 401
    assert b"Cannot delete other user's review." in r.data
