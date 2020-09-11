#!/bin/python3

import requests as req
import os

## requests wrapper
def _request(method:str, target:str,
             data:dict=None, headers:dict=None):
    prep = req.Request(method, target, data=data, headers=headers).prepare()
    # sign = hmac.new(secret, bytes(prep.body, 'utf-8'), digestmod=hashlib.sha256)
    # prep.body += '&signature=' + sign.hexdigest()
    # prep.url += '?' + prep.body
    with req.Session() as ses:
        ans = ses.send(prep)
    ans.raise_for_status()
    return ans

## env wrapper
def getenv(name):
    try:
        return os.environ[name]
    except KeyError:
        raise Exception(f"Expected {name} environment, found nil instead.")

def init_token():
    ## JWT Token for kubernetes authentication backend
    with open('/var/run/secrets/kubernetes.io/serviceaccount/token', 'r') as fs:
        token = fs.read()
    ans = _request('POST',
                   f"{VAULT_ADDR}/v1/auth/kubernetes/login",
                   data={
                       "jwt": f"{token}",
                       "role": "flask-app",
                   }).json()
    return ans['auth']['client_token']

VAULT_ADDR   = getenv("VAULT_ADDR")
XVAULT_TOKEN = init_token()
