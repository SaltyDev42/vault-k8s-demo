#!/bin/bash

export VAULT_ADDR=http://vault.vault.svc.cluster.local:8200
export VAULT_TOKEN=root
#### KeyValue Version 1 ####
vault secrets enable -version=1 -path=vault kv
vault kv put vault/crendentials username=vault password=vault123!

vault policy write secret-consumer /vault/setup/secret-consumer.hcl
