#!/bin/bash

#### POSTGRESQL ####
sshpass ssh root@psql bash -c "echo host vault-flask-app all 0.0.0.0/0 scram-sha-256 >> /var/lib/pgsql/data/pg_hba.conf"
sshpass ssh root@psql bash -c "echo password_encryption = scram-sha-256 >> /var/lib/pgsql/data/postgresql.conf"

sshpass ssh root@psql sudo -u postgres createdb vault-flask-app
sshpass ssh root@psql sudo -u postgres psql -c "create user vault with password 'vault123'"
sshpass ssh root@psql sudo -u postgres psql -c "alter role vault SUPERUSER CREATEROLE"

vault secrets enable database

## FORMAT
## URI : postgres://{username}:{password}@{hostname}:{port}/{db_name}

## CREATE CONFIG ##
vault write database/config/flask-db \
      plugin_name=postgresql-database-plugin \
      allowed_roles="flask-app" \
      connection_url="postgres://{{username}}:{{password}}@192.168.124.20:5432/vault-flask-app?sslmode=disable" \
      username="vault" \
      password="vault123"

## CREATE ROLE ##
vault write database/roles/flask-app \
      db_name="flask-db" \
      creation_statements=@statement.sql \
      revocation_statements=@revocation.sql \
      default_ttl="1h" \
      max_ttl="8h"

## ROTATE ROOT ##
vault write -f database/rotate-root/flask-db

## get credentials
# vault read database/creds/flask-app
## TODO equivalent curl
