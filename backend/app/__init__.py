import logging

from config import Config
from flask import Flask
from flask_cors import CORS
from flask_sqlalchemy import SQLAlchemy
from marshmallow import ValidationError
from sqlalchemy.exc import IntegrityError, SQLAlchemyError
from sqlalchemy.orm.exc import NoResultFound
from ua_parser import user_agent_parser
from werkzeug.exceptions import BadRequest, NotFound
from werkzeug.user_agent import UserAgent
from werkzeug.utils import cached_property


class ParsedUserAgent(UserAgent):
    @cached_property
    def _details(self):
        return user_agent_parser.Parse(self.string)

    @property
    def platform(self):
        return self._details["os"]["family"]


db = SQLAlchemy()


def create_app(test_config=None):
    app = Flask(__name__)
    app.request_class.user_agent_class = ParsedUserAgent
    CORS(app, supports_credentials=True)

    if test_config is None:
        # load the instance config, if it exists, when not testing
        app.config.from_object(Config)
    else:
        # load the test config if passed in
        app.config.update(test_config)

    db.init_app(app)

    logger = logging.getLogger(__name__)
    FORMAT = "[%(filename)s:%(lineno)s - %(funcName)s()]\n%(message)s"
    logging.basicConfig(format=FORMAT)
    logger.setLevel(logging.DEBUG)

    from app.admin import bp as adminBp
    from app.courses import bp as coursesBp
    from app.lectures import bp as lecturesBp
    from app.reservations import bp as reservationsBp
    from app.reviews import bp as reviewsBp
    from app.search import bp as searchBp
    from app.users import bp as usersBp

    app.register_blueprint(usersBp, url_prefix="/api/users")
    app.register_blueprint(coursesBp, url_prefix="/api/courses")
    app.register_blueprint(lecturesBp, url_prefix="/api/lectures")
    app.register_blueprint(reservationsBp, url_prefix="/api/reservations")
    app.register_blueprint(reviewsBp, url_prefix="/api/reviews")
    app.register_blueprint(searchBp, url_prefix="/api/search")
    app.register_blueprint(adminBp, url_prefix="/api/admin")

    @app.errorhandler(NoResultFound)
    def handleNoResultFound(error):
        app.logger.exception(error)
        return {"msg": "The required resource is not available."}, 404

    @app.errorhandler(NotFound)
    def handleNotFound(error):
        app.logger.exception(error)
        return {"msg": error.description}, 404

    @app.errorhandler(ValidationError)
    def handleValidationError(error):
        app.logger.exception(error)
        return {"msg": error.messages}, 422

    @app.errorhandler(ValueError)
    def handleValueError(error):
        app.logger.exception(error)
        return {"msg": "Invalid request format."}, 422

    @app.errorhandler(BadRequest)
    def handleBadRequestError(error):
        app.logger.exception(error)
        return {"msg": "Bad request."}, 400

    @app.errorhandler(TypeError)
    def handleTypeError(error):
        app.logger.exception(error)
        return {"msg": "Bad request."}, 400

    @app.errorhandler(IntegrityError)
    def handleIntegrityError(error):
        app.logger.exception(error)
        return {"msg": "Already exists."}, 409

    @app.errorhandler(SQLAlchemyError)
    def handleSQLError(error):
        app.logger.exception(error)
        return {"msg": "Something went wrong."}, 500

    @app.errorhandler(Exception)
    def handleGenericException(error):
        app.logger.exception(error)
        return {"msg": "Something went wrong."}, 500

    @app.route("/api/ping")
    def ping():
        return {"msg": "pong"}, 200

    return app
