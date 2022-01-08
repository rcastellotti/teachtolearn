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


CORRECT_SAW_LECTURE = dict(
    courseAbbreviation="SAW",
    summary="PHP",
    date="2022-03-13",
    start="10:00:00",
    end="12:00:00",
)


def addLecture(client, lecture=CORRECT_SO_LECTURE):
    r = client.post("/api/lectures/addLecture", json=lecture)
    assert r.status_code == 200


CORRECT_SO_REVIEW = dict(rating=10, review="Ottimo")

CORRECT_SAW_REVIEW = dict(rating=10, review="Corso ben organizzato")


def addReview(client, courseAbbreviation="SO", review=CORRECT_SO_REVIEW):
    r = client.post(f"/api/reviews/addReview/{courseAbbreviation}", json=review)
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

    from app.models import User

    User.query.filter(User.username == "fabifont").update({"isAdmin": True})
    db.session.commit()

    signIn(client)
    addCourse(client)
    addLecture(client)
    r = client.get("/api/lectures/SO")
    data1 = json.loads(r.data)
    signIn(client, "me@rcastellotti.dev", "ilovebears")
    addCourse(client, CORRECT_SAW_COURSE)
    addLecture(client, CORRECT_SAW_LECTURE)
    r = client.get("/api/lectures/SAW")
    data2 = json.loads(r.data)

    from app.models import Lecture

    Lecture.query.filter(Lecture.id == data1["msg"]["lectures"][0]["id"]).update(
        {"date": "2020-03-13"}
    )
    Lecture.query.filter(Lecture.id == data2["msg"]["lectures"][0]["id"]).update(
        {"date": "2020-03-13"}
    )

    signIn(client, "federico.fontana2000@gmail.com", "ilovecats")
    addReservation(client)
    addReservation(client, "SAW")
    addReview(client)
    addReview(client, "SAW", CORRECT_SAW_REVIEW)
    signOut(client)


def testGetUsers(client):
    signIn(client)
    r = client.get("/api/admin/getUsers")
    assert r.status_code == 200
    data = json.loads(r.data)
    assert len(data["msg"]["users"]) == 3


def testGetCourses(client):
    signIn(client)
    r = client.get("/api/admin/getCourses")
    assert r.status_code == 200
    data = json.loads(r.data)
    assert len(data["msg"]["courses"]) == 2


def testGetLectures(client):
    signIn(client)
    r = client.get("/api/admin/getLectures")
    assert r.status_code == 200
    data = json.loads(r.data)
    assert len(data["msg"]["lectures"]) == 2


def testGetReviews(client):
    signIn(client)
    r = client.get("/api/admin/getReviews")
    assert r.status_code == 200
    data = json.loads(r.data)
    assert len(data["msg"]["reviews"]) == 2


def testGetSessions(client):
    signIn(client)
    r = client.get("/api/admin/getSessions")
    assert r.status_code == 200
    data = json.loads(r.data)
    assert len(data["msg"]["sessions"]) == 1


def testBanUser(client):
    signIn(client)

    r = client.get("/api/admin/getUsers")
    assert r.status_code == 200
    data = json.loads(r.data)

    r = client.delete(f"/api/admin/user/{data['msg']['users'][0]['id']}")
    assert r.status_code == 200
    assert b"User banned successfully." in r.data


def testBanUserNotFound(client):
    signIn(client)
    r = client.delete("/api/admin/user/abc123")
    assert r.status_code == 404
    assert b"User not found or you are trying to ban an admin." in r.data


def testBanUserUnauthorized(client):
    signIn(client)

    r = client.get("/api/admin/getUsers")
    assert r.status_code == 200
    data = json.loads(r.data)

    r = client.delete(f"/api/admin/user/{data['msg']['users'][2]['id']}")
    assert r.status_code == 404
    assert b"User not found or you are trying to ban an admin." in r.data


def testUnbanUser(client):
    signIn(client)

    r = client.get("/api/admin/getUsers")
    assert r.status_code == 200
    data = json.loads(r.data)

    r = client.put(f"/api/admin/user/{data['msg']['users'][0]['id']}")
    assert r.status_code == 200
    assert b"User unbanned successfully." in r.data


def testUnbanUserNotFound(client):
    signIn(client)
    r = client.put("/api/admin/user/abc123")
    assert r.status_code == 404
    assert b"User not found or you are trying to unban an admin." in r.data


def testUnbanUserUnauthorized(client):
    signIn(client)

    r = client.get("/api/admin/getUsers")
    assert r.status_code == 200
    data = json.loads(r.data)

    r = client.put(f"/api/admin/user/{data['msg']['users'][2]['id']}")
    assert r.status_code == 404
    assert b"User not found or you are trying to unban an admin." in r.data


def testBanCourse(client):
    signIn(client)
    r = client.delete("/api/admin/course/SAW")
    assert r.status_code == 200
    assert b"Course banned successfully." in r.data


def testBanCourseNotFound(client):
    signIn(client)
    r = client.delete("/api/admin/course/TAC")
    assert r.status_code == 404
    assert b"Course not found." in r.data


def testUnbanCourse(client):
    signIn(client)
    r = client.put("/api/admin/course/SAW")
    assert r.status_code == 200
    assert b"Course unbanned successfully." in r.data


def testUnbanCourseNotFound(client):
    signIn(client)
    r = client.put("/api/admin/course/TAC")
    assert r.status_code == 404
    assert b"Course not found." in r.data


def testBanLecture(client):
    signIn(client)
    r = client.get("/api/lectures/SAW")
    data = json.loads(r.data)

    r = client.delete(f"/api/admin/lecture/{data['msg']['lectures'][0]['id']}")
    assert r.status_code == 200
    assert b"Lecture banned successfully." in r.data


def testBanLectureNotFound(client):
    signIn(client)
    r = client.delete("/api/admin/lecture/abc123")
    assert r.status_code == 404
    assert b"Lecture not found." in r.data


def testUnbanLecture(client):
    signIn(client)
    r = client.get("/api/lectures/SAW")
    data = json.loads(r.data)

    r = client.put(f"/api/admin/lecture/{data['msg']['lectures'][0]['id']}")
    assert r.status_code == 200
    assert b"Lecture unbanned successfully." in r.data


def testUnbanLectureNotFound(client):
    signIn(client)
    r = client.put("/api/admin/lecture/abc123")
    assert r.status_code == 404
    assert b"Course or lecture not found." in r.data


def testUnbanLectureFullCourse(client):
    signIn(client)
    r = client.get("/api/lectures/SAW")
    data = json.loads(r.data)
    r = client.delete(f"/api/admin/lecture/{data['msg']['lectures'][0]['id']}")
    assert r.status_code == 200
    assert b"Lecture banned successfully." in r.data
    signIn(client, "me@rcastellotti.dev", "ilovebears")
    for i in range(20):
        lecture = dict(
            courseAbbreviation="SAW",
            summary="PHP",
            date=f"2022-03-{i + 1}",
            start="08:00:00",
            end="10:00:00",
        )
        addLecture(client, lecture)
    signIn(client)
    r = client.put(f"/api/admin/lecture/{data['msg']['lectures'][0]['id']}")
    assert r.status_code == 409
    assert b"Cannot unban lecture for a course that already has 20 lectures." in r.data


def testBanReview(client):
    signIn(client)
    r = client.get("/api/reviews/SAW")
    assert r.status_code == 200
    data = json.loads(r.data)

    r = client.delete(f"/api/admin/review/{data['msg']['reviews'][0]['id']}")
    assert r.status_code == 200
    assert b"Review banned successfully." in r.data


def testBanReviewNotFound(client):
    signIn(client)
    r = client.delete("/api/admin/review/abc123")
    assert r.status_code == 404
    assert b"Review not found." in r.data


def testUnbanReview(client):
    signIn(client)
    r = client.get("/api/reviews/SAW")
    assert r.status_code == 200
    data = json.loads(r.data)

    r = client.put(f"/api/admin/review/{data['msg']['reviews'][0]['id']}")
    assert r.status_code == 200
    assert b"Review unbanned successfully." in r.data


def testUnbanReviewNotFound(client):
    signIn(client)
    r = client.put("/api/admin/review/abc123")
    assert r.status_code == 404
    assert b"Review not found." in r.data
