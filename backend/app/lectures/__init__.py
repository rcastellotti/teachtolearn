from flask import Blueprint

bp = Blueprint("lectures", __name__)

from app.lectures import routes
