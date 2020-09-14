#!/bin/bash

## DELAY JOB
export HOME=/tmp

psql -c "CREATE TABLE ccn_fpe(_id integer PRIMARY KEY, cc varchar, tweak varchar)" postgres://$POSTGRES_USER:$POSTGRES_PASSWORD@postgres.flask-app.svc.cluster.local:5432/$POSTGRES_DB 
