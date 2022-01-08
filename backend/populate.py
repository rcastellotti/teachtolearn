import json
import logging
import random

from app.constants import ICONS

import nanoid
import requests
from pygments import formatters, highlight, lexers

logging.basicConfig(level=logging.INFO)

logger = logging.getLogger("populate.py")

baseUrl = "http://localhost:5000/api/"

lorem = "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua."

armon_dadgar = {
    "username": "armon_dadgar",
    "email": "armon_dadgar@fakeunige.it",
    "password": "armon_dadgar",
    "fullname": "Armon Dagdar",
    "bio": lorem,
}
edsger_dijkstra = {
    "username": "edsger_dijkstra",
    "email": "edsger_dijkstra@fakeunige.it",
    "password": "edsger_dijkstra",
    "fullname": "Edsger Dijkstra",
    "bio": lorem,
}
roberto_castellotti = {
    "username": "rcastellotti",
    "email": "me@rcastellotti.dev",
    "password": "rcastellotti",
    "fullname": "Roberto Castellotti",
    "bio": lorem,
}
federico_fontana = {
    "username": "federico_fontana",
    "email": "s4835118@studenti.fakeunige.it",
    "password": "federico_fontana_password",
    "fullname": "Federico Fontana",
    "bio": lorem,
}
fabio_fontana = {
    "username": "fabifont",
    "email": "s4891185@studenti.unige.it",
    "password": "fabifont",
    "fullname": "Fabio Fontana",
    "bio": lorem,
}
courseNames = [
    "Introduction to the HashiCorp Stack",
    "Logic, Automata, and Complexity",
    "Introduction to Computer Graphics and Imaging",
    "Operating Systems and Systems Programming",
    "Artificial Intelligence: Principles and Techniques",
]

maxStudents = [60, 20, 40, 160, 50, 90, 10, 100, 400]

userAgents = [
    "Mozilla/5.0 (iPhone; CPU iPhone OS 12_2 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Mobile/15E148",
    "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/74.0.3729.169 Safari/537.36",
    "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_11_6) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/11.1.2 Safari/605.1.15",
    "Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/44.0.2403.157 Safari/537.36",
    "Mozilla/5.0 (Linux; Android 8.0.0; SM-G960F Build/R16NW) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/62.0.3202.84 Mobile Safari/537.36",
]

users = [
    fabio_fontana,
    roberto_castellotti,
    federico_fontana,
    edsger_dijkstra,
    armon_dadgar,
]

for user in users:
    headers = {
        "Content-Type": "application/json",
        "User-Agent": random.choice(userAgents),
    }
    response = requests.post(
        baseUrl + "users/signUp", json.dumps(user), headers=headers
    )
    logger.info(
        "\n%s",
        highlight(
            json.dumps(response.json(), indent=4),
            lexers.JsonLexer(),
            formatters.TerminalFormatter(),
        ),
    )


class Course:
    def __init__(
        self,
        name,
        abbreviation,
        icon,
        maxStudents,
    ):
        self.name = name
        self.abbreviation = abbreviation
        self.icon = icon
        self.syllabus = lorem
        self.maxStudents = maxStudents
        self.address = "Via Dodecaneso, 16146 Genova Metropolitan CityGenoa, Italy"
        self.longitude = "8.96940579031976"
        self.latitude = "44.4014427672185"


startEnd = [
    ["2021-02-01", "14:00:00", "16:00:00"],
    ["2021-02-03", "14:00:00", "16:00:00"],
    ["2021-02-05", "14:00:00", "16:00:00"],
    ["2021-02-07", "14:00:00", "16:00:00"],
    ["2021-02-09", "14:00:00", "16:00:00"],
    ["2021-02-11", "14:00:00", "16:00:00"],
    ["2021-02-13", "14:00:00", "16:00:00"],
    ["2021-02-15", "14:00:00", "16:00:00"],
    ["2021-02-17", "14:00:00", "16:00:00"],
    ["2021-02-19", "14:00:00", "16:00:00"],
    ["2021-02-21", "14:00:00", "16:00:00"],
    ["2021-02-23", "14:00:00", "16:00:00"],
    ["2021-02-23", "14:00:00", "16:00:00"],
    ["2021-02-27", "14:00:00", "16:00:00"],
    ["2021-02-28", "14:00:00", "16:00:00"],
]

generatedCoursesAbbreviations = []

for user in users:
    headers = {
        "Content-Type": "application/json",
        "User-Agent": random.choice(userAgents),
    }

    s = requests.Session()
    response = s.post(
        baseUrl + "users/signIn",
        json.dumps({key: user[key] for key in ["email", "password"]}),
        headers=headers,
    )
    logger.info(
        "\n%s",
        highlight(
            json.dumps(response.json(), indent=4),
            lexers.JsonLexer(),
            formatters.TerminalFormatter(),
        ),
    )
    for _ in range(10):
        abbreviation = nanoid.generate(size=4)

        generatedCoursesAbbreviations.append(abbreviation)

        course = Course(
            name=random.choice(courseNames),
            abbreviation=abbreviation,
            icon=f"bi-{random.choice(ICONS)}",
            maxStudents=random.choice(maxStudents),
        )
        response = s.post(
            baseUrl + "courses/addCourse",
            json.dumps(vars(course)),
            headers=headers,
        )
        logger.info(
            "\n%s",
            highlight(
                json.dumps(response.json(), indent=4),
                lexers.JsonLexer(),
                formatters.TerminalFormatter(),
            ),
        )
        for i in startEnd:
            lecture = {
                "courseAbbreviation": abbreviation,
                "summary": f"{abbreviation} - lorem ipsum dolor summary",
                "date": i[0],
                "start": i[1],
                "end": i[2],
            }
            response = s.post(
                baseUrl + "lectures/addLecture",
                json.dumps(lecture),
                headers=headers,
            )
            logger.info(
                "\n%s",
                highlight(
                    json.dumps(response.json(), indent=4),
                    lexers.JsonLexer(),
                    formatters.TerminalFormatter(),
                ),
            )

for user in users:
    headers = {
        "Content-Type": "application/json",
        "User-Agent": random.choice(userAgents),
    }

    s = requests.Session()
    response = s.post(
        baseUrl + "users/signIn",
        json.dumps({key: user[key] for key in ["email", "password"]}),
        headers=headers,
    )
    logger.info(
        "\n%s",
        highlight(
            json.dumps(response.json(), indent=4),
            lexers.JsonLexer(),
            formatters.TerminalFormatter(),
        ),
    )
    # randomly enroll in courses if possible
    for abbreviation in generatedCoursesAbbreviations:
        response = s.post(
            baseUrl + f"reservations/{abbreviation}",
        )
        logger.info(
            "\n%s",
            highlight(
                json.dumps(response.json(), indent=4),
                lexers.JsonLexer(),
                formatters.TerminalFormatter(),
            ),
        )
        rating = random.randint(0, 10)

        lenModifier = random.random()
        review = "lorem, ipsum ipsum. bacon impsum."
        if lenModifier < 0.2:
            review = "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt"
        elif 0.2 <= lenModifier < 0.5:
            review = "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua."
        elif 0.5 <= lenModifier < 0.7:
            review = "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat."
        elif 0.5 <= lenModifier < 0.9:
            review = "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat."
        else:
            review = "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut"

        response = s.post(
            baseUrl + f"reviews/addReview/{abbreviation}",
            json.dumps({"rating": rating, "review": review}),
            headers=headers,
        )
        logger.info(
            "\n%s",
            highlight(
                json.dumps(response.json(), indent=4),
                lexers.JsonLexer(),
                formatters.TerminalFormatter(),
            ),
        )
