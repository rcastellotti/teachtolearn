import click
from app import create_app, db
from app.models import User
from flask.cli import with_appcontext

app = create_app()


@click.command("createdb")
@with_appcontext
def createdb():
    db.create_all()


@click.command("dropdb")
@with_appcontext
def dropdb():
    db.drop_all()


@click.command("promote")
@click.option("--u")
@with_appcontext
def promote(u):
    result = User.query.filter(User.username == u).update({"isAdmin": True})
    if result == 0:
        db.session.rollback()
        print("User not found.")
    else:
        db.session.commit()
        print("User promoted.")


app.cli.add_command(createdb)
app.cli.add_command(dropdb)
app.cli.add_command(promote)
