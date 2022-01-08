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

    signIn(client)
    addCourse(client)
    signOut(client)


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
    assert b"Lecture created successfully." in r.data


def testAddLecture(client):
    signIn(client)
    addLecture(client)


def testAddLectureMissingCourseAbbreviation(client):
    signIn(client)
    r = client.post(
        "/api/lectures/addLecture",
        json=dict(
            summary="Syscall", date="2022-03-13", start="08:00:00", end="10:00:00"
        ),
    )
    assert r.status_code == 422


def testAddLectureMalformedCourseAbbreviation(client):
    signIn(client)
    r = client.post(
        "/api/lectures/addLecture",
        json=dict(
            courseAbbreviation="SOSOSOSOSOSO",
            summary="Syscall",
            date="2022-03-13",
            start="08:00:00",
            end="10:00:00",
        ),
    )
    assert r.status_code == 422


def testAddLectureMalformedDate(client):
    signIn(client)
    r = client.post(
        "/api/lectures/addLecture",
        json=dict(
            courseAbbreviation="SO",
            summary="Syscall",
            date="13/03/2022",
            start="08:00:00",
            end="10:00:00",
        ),
    )
    assert r.status_code == 422


def testAddLectureMalformedStart(client):
    signIn(client)
    r = client.post(
        "/api/lectures/addLecture",
        json=dict(
            courseAbbreviation="SO",
            summary="Syscall",
            date="2022-03-13",
            start="8:00",
            end="10:00:00",
        ),
    )
    assert r.status_code == 422


def testAddLectureInvalidDate(client):
    signIn(client)
    r = client.post(
        "/api/lectures/addLecture",
        json=dict(
            courseAbbreviation="SO",
            summary="Syscall",
            date="2000-03-13",
            start="08:00:00",
            end="10:00:00",
        ),
    )
    assert r.status_code == 422


def testAddLectureCourseNotFound(client):
    signIn(client)
    r = client.post(
        "/api/lectures/addLecture",
        json=dict(
            courseAbbreviation="TAC",
            summary="Automi",
            date="2022-03-13",
            start="08:00:00",
            end="10:00:00",
        ),
    )
    assert r.status_code == 404
    assert b"Course not found." in r.data


def testAddLectureUnauthorized(client):
    signIn(client, "me@rcastellotti.dev", "ilovebears")
    r = client.post(
        "/api/lectures/addLecture",
        json=dict(
            courseAbbreviation="SO",
            summary="Syscall",
            date="2022-03-13",
            start="08:00:00",
            end="10:00:00",
        ),
    )
    assert r.status_code == 401
    assert b"Cannot add lecture to other user's course." in r.data


def testAddLectureLimitReached(client):
    signIn(client)
    for i in range(20):
        lecture = dict(
            courseAbbreviation="SO",
            summary="Syscall",
            date=f"2022-03-{1 + i}",
            start="08:00:00",
            end="10:00:00",
        )
        addLecture(client, lecture)
    r = client.post(
        "/api/lectures/addLecture",
        json=dict(
            courseAbbreviation="SO",
            summary="Syscall",
            date="2022-03-25",
            start="08:00:00",
            end="10:00:00",
        ),
    )
    assert r.status_code == 400
    assert b"Limit of 20 lectures per course already reached." in r.data


def testAddLectureStartBeforePrevious(client):
    signIn(client)
    addLecture(client)
    r = client.post(
        "/api/lectures/addLecture",
        json=dict(
            courseAbbreviation="SO",
            summary="Syscall",
            date="2022-03-13",
            start="06:00:00",
            end="08:00:00",
        ),
    )
    assert r.status_code == 422
    assert b"Lecture must start after the end of the previous one." in r.data


def testGetLectures(client):
    signIn(client)
    addLecture(client)
    signOut(client)

    r = client.get("/api/lectures/SO")
    assert r.status_code == 200
    data = json.loads(r.data)
    assert len(data["msg"]["lectures"]) == 1


def testGetLecturesCourseNotFound(client):
    r = client.get("/api/lectures/SAW")
    assert r.status_code == 404
    assert b"Course not found." in r.data


def testGetNextLectures(client):
    signIn(client)
    for i in range(10):
        lecture = dict(
            courseAbbreviation="SO",
            summary="Syscall",
            date=f"2022-03-{13 + i}",
            start="08:00:00",
            end="10:00:00",
        )
        addLecture(client, lecture)

    signIn(client, "me@rcastellotti.dev", "ilovebears")
    addReservation(client, "SO")
    r = client.get("/api/lectures/getNextLectures")
    assert r.status_code == 200
    data = json.loads(r.data)
    assert len(data["msg"]["lectures"]) == 10


def testUpdateLecture(client):
    signIn(client)
    addLecture(client)

    r = client.get("/api/lectures/SO")
    assert r.status_code == 200
    data = json.loads(r.data)
    assert len(data["msg"]["lectures"]) == 1

    r = client.put(
        f"/api/lectures/{data['msg']['lectures'][0]['id']}",
        json=dict(
            summary="Syscall", date="2022-03-13", start="09:00:00", end="11:00:00"
        ),
    )

    assert r.status_code == 200
    assert b"Lecture updated successfully." in r.data


def testUpdateLectureMalformedStart(client):
    signIn(client)
    addLecture(client)

    r = client.get("/api/lectures/SO")
    assert r.status_code == 200
    data = json.loads(r.data)
    assert len(data["msg"]["lectures"]) == 1

    r = client.put(
        f"/api/lectures/{data['msg']['lectures'][0]['id']}",
        json=dict(summary="Syscall", date="2022-03-13", start="9:00", end="11:00:00"),
    )

    assert r.status_code == 422


def testUpdateLectureMalformedDate(client):
    signIn(client)
    addLecture(client)

    r = client.get("/api/lectures/SO")
    assert r.status_code == 200
    data = json.loads(r.data)
    assert len(data["msg"]["lectures"]) == 1

    r = client.put(
        f"/api/lectures/{data['msg']['lectures'][0]['id']}",
        json=dict(
            summary="Syscall", date="13/03/2022", start="09:00:00", end="11:00:00"
        ),
    )

    assert r.status_code == 422


def testUpdateLectureInvalidDate(client):
    signIn(client)
    addLecture(client)

    r = client.get("/api/lectures/SO")
    assert r.status_code == 200
    data = json.loads(r.data)
    assert len(data["msg"]["lectures"]) == 1

    r = client.put(
        f"/api/lectures/{data['msg']['lectures'][0]['id']}",
        json=dict(
            summary="Syscall", date="2000-03-13", start="09:00:00", end="11:00:00"
        ),
    )

    assert r.status_code == 422


def testUpdateLectureUnauthorized(client):
    signIn(client)
    addLecture(client)

    r = client.get("/api/lectures/SO")
    assert r.status_code == 200
    data = json.loads(r.data)
    assert len(data["msg"]["lectures"]) == 1

    signOut(client)
    signIn(client, "me@rcastellotti.dev", "ilovebears")

    r = client.put(
        f"/api/lectures/{data['msg']['lectures'][0]['id']}",
        json=dict(
            summary="Syscall", date="2022-03-13", start="09:00:00", end="11:00:00"
        ),
    )

    assert r.status_code == 401
    assert b"Cannot edit other user's lecture." in r.data


def testUpdateLectureNotFound(client):
    signIn(client)
    r = client.put(
        "/api/lectures/abc123",
        json=dict(
            summary="Syscall", date="2022-03-13", start="09:00:00", end="11:00:00"
        ),
    )
    assert r.status_code == 404
    assert b"Lecture not found." in r.data


def testDeleteLecture(client):
    signIn(client)
    addLecture(client)

    r = client.get("/api/lectures/SO")
    assert r.status_code == 200
    data = json.loads(r.data)
    assert len(data["msg"]["lectures"]) == 1

    r = client.delete(f"/api/lectures/{data['msg']['lectures'][0]['id']}")
    assert r.status_code == 200
    assert b"Lecture deleted successfully." in r.data


def testDeleteLectureNotFound(client):
    signIn(client)
    r = client.delete("/api/lectures/abcde12345678")
    assert r.status_code == 404
    assert b"Lecture not found." in r.data


def testDeleteLectureUnauthorized(client):
    signIn(client)
    addLecture(client)

    r = client.get("/api/lectures/SO")
    assert r.status_code == 200
    data = json.loads(r.data)
    assert len(data["msg"]["lectures"]) == 1

    signOut(client)
    signIn(client, "me@rcastellotti.dev", "ilovebears")

    r = client.delete(f"/api/lectures/{data['msg']['lectures'][0]['id']}")
    assert r.status_code == 401
    assert b"Cannot delete other user's lecture." in r.data
