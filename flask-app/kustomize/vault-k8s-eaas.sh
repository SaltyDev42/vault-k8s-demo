#!/bin/bash

export VAULT_ADDR=http://vault.vault.svc.cluster.local:8200
export VAULT_TOKEN=root

vault policy write flask-app /vault/setup/flask-app.hcl

vault write auth/kubernetes/role/flask-app bound_service_account_names=flask-app bound_service_account_namespaces=flask-app token_policies=default,flask-app

sh /vault/setup/vault-k8s-demo-transform.sh
sh /vault/setup/vault-k8s-demo-transit.sh
