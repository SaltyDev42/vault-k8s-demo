#!/bin/bash

export VAULT_ADDR=http://vault.vault.svc.cluster.local:8200
export VAULT_TOKEN=root
#### KeyValue Version 1 ####
vault secrets enable -version=1 -path=vault kv
vault kv put vault/credentials username=vault password=vault123!

vault policy write secret-consumer /vault/setup/secret-consumer.hcl
vault write auth/kubernetes/role/secret-consumer bound_service_account_names=secret-consumer bound_service_account_namespaces=vault-kv1 token_policies=default,secret-consumer
