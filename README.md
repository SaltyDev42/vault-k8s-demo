# vault-demo
This project demonstrate how one can implement vault features into kubernetes.  
Demo are seperated into 2 part, fisrt demonstrating kv1, and second demonstrating
transit, transform and database engine using Flask as web framework.
The following vault engines were used: kv1, transform, transit, database engine  

## Requirement
- Vault License with "Advanced Protection Module" (Transform is not included in premium)
- some kind of Orchestrator, tested on Openshift 4.5, might work on Kubernetes, I don't know about docker-swarm
- Helm Chart to install vault as pod in Openshift/Kubernetes

## Install
A license must be provided at `setup/vault.hclic`
```
helm add repo hashicorp/vault
helm install vault hashicorp/vault -n vault --create-namespace -f values.yaml
oc apply -k setup
oc apply -k kv1
oc apply -k postgres
oc apply -k flask-app/kustomize
```

## Software used
- Openshift
- Vault 1.5.3
- Postgresql 12
- Flask
- Python3 (obviously)
- Apache

## Notes
A demo license can be obtained from Hashicorp using the following link
https://www.hashicorp.com/request-demo/vault
