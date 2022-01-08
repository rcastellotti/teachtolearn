import datetime

import jwt
from app.constants import FROM_EMAIL, JWT_SECRET, SENDGRID_API_KEY
from flask import current_app as a
from jinja2 import Environment, PackageLoader, select_autoescape
from sendgrid import SendGridAPIClient
from sendgrid.helpers.mail import Mail

sg = SendGridAPIClient(SENDGRID_API_KEY)

env = Environment(loader=PackageLoader("app.users"), autoescape=select_autoescape())


def generateToken(email, type):
    """
    Generic function to generate JWT tokens for email stuff

    Parameters
    ----------
    email : str
    type : 'activationToken' | 'passwordResetToken'

    Returns
    -------
    token: str
    """

    payload = {
        "type": type,
        "email": email,
        "exp": datetime.datetime.now() + datetime.timedelta(hours=24),
    }

    token = jwt.encode(payload, JWT_SECRET, algorithm="HS256")

    return token


def sendActivationEmail(toEmail, username, token):
    template = env.get_template("activation-email-template.html.jinja2")

    message = Mail(
        from_email=FROM_EMAIL,
        to_emails=toEmail,
        subject="Activate your teachtolearn account",
        html_content=template.render(username=username, token=token),
    )
    try:
        r = sg.send(message)
        a.logger.debug("sendgrid: %s - %s", r.status_code, r.body)
    except Exception as e:
        a.logger.error(str(e))


def sendResetPasswordEmail(toEmail, username, token):
    template = env.get_template("password-reset-email-template.html.jinja2")

    message = Mail(
        from_email=FROM_EMAIL,
        to_emails=toEmail,
        subject="Reset your teachtolearn password",
        html_content=template.render(username=username, token=token),
    )
    try:
        r = sg.send(message)
        a.logger.debug("sendgrid: %s - %s", r.status_code, r.body)
    except Exception as e:
        a.logger.error(str(e))
