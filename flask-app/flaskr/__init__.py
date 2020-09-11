#!/bin/python3

from flask import Flask
from flask import g
from flask_sqlalchemy import SQLAlchemy
from flaskr.ccn_fpe import db
from flask_migrate import Migrate

app = Flask(__name__)

def db_uri():
    with open('/app/config/db.uri', 'r') as fs:
        _uri = fs.read()
    return _uri

## db init
app.config["SQLALCHEMY_DATABASE_URI"] = db_uri()
app.config["SQLALCHEMY_TRACK_MODIFICATIONS"] = False
db.init_app(app)
migrate = Migrate(app, db)

@app.before_first_request
def init():
    db.create_all()

from flaskr import transform
app.register_blueprint(transform.bp)
