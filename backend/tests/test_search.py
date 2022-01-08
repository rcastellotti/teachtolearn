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
    signIn(client, "me@rcastellotti.dev", "ilovebears")
    addCourse(client, CORRECT_SAW_COURSE)
    signOut(client)


def testSearch(client):
    r = client.get("api/search?q=s")
    assert r.status_code == 200
    data = json.loads(r.data)
    assert len(data["msg"]["courses"]) == 2 and len(data["msg"]["users"]) == 1


def testSearchMissingParameters(client):
    r = client.get("api/search")
    assert r.status_code == 400
    assert b"Query must be provided." in r.data


def testSearchRealtime(client):
    r = client.get("api/search/realtime?q=s")
    assert r.status_code == 200
    data = json.loads(r.data)
    assert len(data["msg"]["courses"]) == 2 and len(data["msg"]["users"]) == 1


def testSearchRealtimeMissingParameters(client):
    r = client.get("api/search/realtime")
    assert r.status_code == 400
    assert b"Query must be provided." in r.data
