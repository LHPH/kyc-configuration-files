#!/bin/bash
set -e

domain=$1

if [ -z "$domain" ]; then
  echo "Missing first required argument"
  exit 1
fi

openssl s_client -connect $domain:443 -showcerts 2>/dev/null | \
openssl x509 -pubkey -noout | \
openssl pkey -pubin -outform der | \
openssl dgst -sha256 -binary | \
openssl enc -base64