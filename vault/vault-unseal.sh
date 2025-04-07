#!/bin/bash -x
set -e
export VAULT_ADDR='http://127.0.0.1:8200'

mapfile -t keyArray < /etc/vault.d/vault-unseal.txt

vault operator unseal ${keyArray[0]}
vault operator unseal ${keyArray[1]}
vault operator unseal ${keyArray[2]}