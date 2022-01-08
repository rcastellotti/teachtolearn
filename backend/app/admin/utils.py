from functools import wraps

from app import utils


def adminRoute(func):
    @wraps(func)
    def adminRouteWrapper(*args, **kwargs):
        session = utils.getSession()
        if not session:
            return {"msg": "Authentication required."}, 401
        if not session.user.isAdmin:
            return {"msg": "Restricted route."}, 401
        return func(*args, **kwargs)

    return adminRouteWrapper
