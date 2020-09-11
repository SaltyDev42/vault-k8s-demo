#!/bin/bash

#### TRANFORM ####
vault secrets enable transform

## GENERATED TWEAK ##
## BEST ##
vault write transform/transformation/cc \
  type=fpe \
  template=ccn \
  tweak_source=generated \
  allowed_roles=generated

vault write transform/role/generated transformations=cc
vault write transform/template/ccn \
  type=regex \
  pattern='(\d{4})-(\d{4})-(\d{4})-(\d{4})' \
  alphabet=numerics

vault write transform/alphabet/numerics \
      alphabet="0123456789"

## INTERNAL TWEAK ##
## NO GOOD ##
vault write transform/transformation/cc-internal \
      type=fpe \
      template=ccn \
      tweak_source=internal \
      allowed_roles=internal

vault write transform/role/internal transformations=cc-internal

## NOTE Internal has only 1 tweak as encryption and will reuse it infinitely, but Generated will generate a tweak as encryption and use different one each time
## but you must provide tweak when decoding
