#!/bin/bash

export VAULT_ADDR=http://vault.vault.svc.cluster.local:8200
export VAULT_TOKEN=root

vault write sys/license text=@/vault/hclic/vault.hclic

### INTERNAL VAULT SETUP
vault auth enable kubernetes

vault write auth/kubernetes/config \
        token_reviewer_jwt="$(cat /var/run/secrets/kubernetes.io/serviceaccount/token)" \
        kubernetes_host="https://$KUBERNETES_PORT_443_TCP_ADDR:443" \
        kubernetes_ca_cert=@/var/run/secrets/kubernetes.io/serviceaccount/ca.crt

# vault write auth/kubernetes/config \
#         token_reviewer_jwt="$(cat /run/secrets/kubernetes.io/serviceaccount/token)" \
#         kubernetes_host="$KUBERNETES_SERVICE_HOST" \
#         kubernetes_ca_cert="$(cat /run/secrets/kubernetes.io/serviceaccount/ca.crt)"


### EXTERNAL VAULT SETUP
# VAULT_SA_NAME=$(kubectl get sa vault-auth -o json | jq -r .secrets[].name | grep token)
# SA_JWT_TOKEN=$(kubectl get secret $VAULT_SA_NAME -o jsonpath="{.data.token}" | base64 --decode; echo)
# SA_CA_CRT=$(kubectl get secret $VAULT_SA_NAME -o jsonpath="{.data['ca\.crt']}" | base64 --decode; echo)

# vault auth enable kubernetes
# vault write auth/kubernetes/config \
#         token_reviewer_jwt="$SA_JWT_TOKEN" \
#         kubernetes_host="https://api.crc.testing:6443" \
#         kubernetes_ca_cert="$SA_CA_CRT"
