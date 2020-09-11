#!/bin/bash

#### TRANSIT ####

vault secrets enable transit
vault write -f transit/keys/cc-tweak
## rotate
# vault write -f transit/keys/cc-tweak/rotate

## endpoint
# encrypt transit/encrypt/cc-tweak
# decrypt transit/decrypt/cc-tweak
# rewrap  transit/rewrap/cc-tweak

## get datakey
# transit/datakey/{plaintext,wrapped}/cc-tweak

## JSON format
# {
#     "batch_input": [
#         {
#             "plaintext": "dGVzdAo="
#         }
#     ]
# }

