#!/bin/bash

## install vault-k8s injector into OC
helm repo add hashicorp https://helm.releases.hashicorp.com
## TODO >> template values.yaml
helm install hashicorp/vault --namespace vault --create-namespace -f values.yaml

## KV1 setup
vault secrets enable kv --path=vault --version=1
vault secrets tune -default-lease-ttl=30s -max-lease-ttl=3600s  vault
vault write vault/credentials username=vault password=vault123!

## KV2 setup??


## Certificate was signed using the following SAN >> DNS:*.apps<domain>, DNS:api.<domain>, IP: private IP
## PATCH API ENDPOINT
oc create secret tls api-tls  --cert=ocp.crt.pem --key=ocp.key.pem  -n openshift-config
oc patch apiserver cluster --type=merge -p \
     '{"spec": {"servingCerts": {"namedCertificates":[{"names": ["<FQDN>"], "servingCertificate": {"name": "api-tls"}}]}}}'

## PATCH WILDCARD ENDPOINT
oc create configmap custom-ca --from-file=ca-bundle.crt=ca.crt.pem -n openshift-config
oc patch proxy/cluster --type=merge --patch='{"spec":{"trustedCA":{"name":"custom-ca"}}}'
oc create secret tls app-tls --cert=ocp.crt.pem --key=ocp.key.pem -n openshift-ingress
oc patch ingresscontroller.operator default --type=merge -p \
     '{"spec":{"defaultCertificate": {"name": "app-tls"}}}' \
     -n openshift-ingress-operator

## WAIT FEW MINUTES TILL KUBE-APISERVER IS READY NOT BEOFRE
## OTHERWISE CERTIFICATES ARE NOT RECOGNIZED BY VAULT
echo "SLEEP 2min waiting for kube-apiserver to be ready"
sleep 120

## Create cluster role binding system:auth:delegator to vault-auth
oc project vault
oc create sa vault-auth
cat <<EOF | oc apply -f -
apiVersion: rbac.authorization.k8s.io/v1beta1
kind: ClusterRoleBinding
metadata:
  name: role-tokenreview-binding
  namespace: default
roleRef:
  apiGroup: rbac.authorization.k8s.io
  kind: ClusterRole
  name: system:auth-delegator
subjects:
- kind: ServiceAccount
  name: vault-auth
  namespace: vault
EOF


## SETTING UP KUBERNETES AUTHENTIFICATIONS
VAULT_SA_NAME=$(kubectl get sa vault-auth -o json | jq -r .secrets[].name | grep token)
SA_JWT_TOKEN=$(kubectl get secret $VAULT_SA_NAME -o jsonpath="{.data.token}" | base64 --decode; echo)
SA_CA_CRT=$(kubectl get secret $VAULT_SA_NAME -o jsonpath="{.data['ca\.crt']}" | base64 --decode; echo)

vault auth enable kubernetes
vault write auth/kubernetes/config \
        token_reviewer_jwt="$SA_JWT_TOKEN" \
        kubernetes_host="https://api.crc.testing:6443" \
        kubernetes_ca_cert="$SA_CA_CRT"
