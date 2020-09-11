#!/bin/bash

#### KeyValue Version 1 ####
vault secrets enable -version=1 -path=vault kv
vault kv puts vault/crendentials username=vault password=vault123!

vault policy write secret-consumer secret-consumer.hcl
