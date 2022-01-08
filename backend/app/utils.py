import random
import json
from functools import wraps

from app.constants import IS_PROD, COLORS
from app.models import Session
from flask import current_app as a
from flask import request
from nanoid import generate
from pygments import formatters, highlight, lexers


def randomColor():
    return random.choice(COLORS)


def getSession():
    return Session.query.filter(
        Session.sessionToken == request.cookies.get("sessionToken")
    ).first()


def generateNanoid(size=8):
    return generate(size=size)


def logRequest(func):
    @wraps(func)
    def logRequestWrapper(*args, **kwargs):
        if not IS_PROD:
            a.logger.debug(
                "\n%s",
                highlight(
                    json.dumps(request.get_json(), indent=4),
                    lexers.JsonLexer(),
                    formatters.TerminalFormatter(),
                ),
            )
        return func(*args, **kwargs)

    return logRequestWrapper


def authRequired(func):
    @wraps(func)
    def authRequiredWrapper(*args, **kwargs):
        session = getSession()
        if not session:
            return {"msg": "Authentication required."}, 401
        return func(session=session, *args, **kwargs)

    return authRequiredWrapper
