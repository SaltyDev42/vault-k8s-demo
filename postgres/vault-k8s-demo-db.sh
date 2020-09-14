#!/bin/bash

export VAULT_ADDR=http://vault.vault.svc.cluster.local:8200
export VAULT_TOKEN=root

vault secrets enable database

## FORMAT
## URI : postgres://{username}:{password}@{hostname}:{port}/{db_name}

## CREATE CONFIG ##
vault write database/config/flask-db \
      plugin_name=postgresql-database-plugin \
      allowed_roles="flask-app" \
      connection_url="postgres://{{username}}:{{password}}@postgres.flask-app.svc.cluster.local:5432/vault-flask-app?sslmode=disable" \
      username="vault" \
      password="vault123!"

## CREATE ROLE ##
vault write database/roles/flask-app \
      db_name="flask-db" \
      creation_statements=@/vault/setup/statement.sql \
      revocation_statements=@/vault/setup/revocation.sql \
      default_ttl="30s" \
      max_ttl="5m"

## ROTATE ROOT ##
sleep 5s
vault write -f database/rotate-root/flask-db
