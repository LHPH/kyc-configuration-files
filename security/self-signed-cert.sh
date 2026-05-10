#!/bin/bash
set -e



export COMMON_NAME=${1:-localhost}
export IP=${2:-127.0.0.1}

echo "Generating certificate for $COMMON_NAME"
openssl req -config self-signed-cert.conf -newkey rsa -x509 -days 365 -out domain.crt

echo "Renaming key and crt files for $COMMON_NAME"
mv domain.crt $COMMON_NAME.crt
mv domain.key $COMMON_NAME.key