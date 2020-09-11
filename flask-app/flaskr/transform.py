#!/bin/python3


from flask import Blueprint
from flask import g
from flask import redirect
from flask import render_template
from flask import request
from flask import url_for

from flaskr.helper import (_request, VAULT_ADDR, XVAULT_TOKEN)
from flaskr.ccn_fpe import (ccn_fpe, db)

bp = Blueprint("transform", __name__)

## FULL API
# @bp.route("/api/cc/<int:_id>/delete", methods=["DELETE"])
# def fpe_delete(_id):
#     __safe_object = ccn_fpe.query.get(_id)
#     if __safe_object is not None:
#         db.session.delete(__safe_object)
#     return {'code': 200, 'response': 'OK'}

# @bp.route("/api/cc/rewrap", methods=["POST"])
# def fpe_transit_rewrap():
#     for cc in ccn_fpe.query.all():
#         ## request xvault token kubernetes jwt
#         pass

#     db.session.commit()
#     return {'code': 200, 'response': 'OK'}


## success in encoding redirect to /success.html
@bp.route("/encode", methods=["GET","POST"])
def encode():
    if request.method == 'POST':
        ## transform encode cc value
        ans = _request('POST', f"{VAULT_ADDR}/v1/transform/encode/generated",
                       data={
                           'value': request.form['cc']},
                       headers={'X-Vault-Token': XVAULT_TOKEN}).json()['data']
        encoded_value = ans['encoded_value']
        tweak         = ans['tweak']

        ## transit encrypting tweak
        ans = _request('POST', f"{VAULT_ADDR}/v1/transit/encrypt/cc-tweak",
                       data={
                           'plaintext': tweak},
                       headers={'X-Vault-Token': XVAULT_TOKEN}).json()['data']
        tweak = ans['ciphertext']
        ## DB model
        cc = ccn_fpe(encoded_value, tweak)
        db.session.add(cc)
        db.session.commit()
        
        return redirect(url_for("transform.success"))
    return render_template('encode.html')

@bp.route("/success")
def success():
    return render_template("success.html")

@bp.route("/decode/<int:_id>")
def decode(_id):
    cc = ccn_fpe.query.get(_id)
    ## transit decrypt tweak value
    ans = _request('POST', f"{VAULT_ADDR}/v1/transit/decrypt/cc-tweak",
                   data={'ciphertext': cc.tweak},
                   headers={'X-Vault-Token': XVAULT_TOKEN}).json()['data']
    tweak = ans['plaintext']
    ## transform decode cc value
    ans = _request('POST', f"{VAULT_ADDR}/v1/transform/decode/generated",
                   data={'value': cc.cc, 'tweak': tweak},
                   headers={'X-Vault-Token': XVAULT_TOKEN}).json()['data']
    return render_template('decode.html', cc=ans['decoded_value'])

@bp.route("/")
def list():
    return render_template('index.html', ccs=ccn_fpe.query.all())
