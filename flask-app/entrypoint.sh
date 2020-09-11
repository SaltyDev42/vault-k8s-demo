#!/bin/sh

FLASK_APP=flaskr flask db init
FLASK_APP=flaskr flask db migrate
FLASK_APP=flaskr flask db upgrade
FLASK_APP=flaskr flask run -h 0.0.0.0 --extra-files config/db.uri --reload
