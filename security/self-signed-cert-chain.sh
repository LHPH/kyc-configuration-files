#!/bin/bash
set -e
export COMMON_NAME=${1:-localhost}
export IP=${2:-127.0.0.1}
if [ ! -f "root.key" ]; then

    # Generate private key
    echo "Generate root private key"
    openssl genrsa -out root.key 4096
fi

if [ ! -f "root.crt" ]; then

    # Generate self-signed certificate
    echo "Generate self-signed certificate"
    openssl req -x509 -new -nodes -key root.key -sha256 -days 3650 -config root.conf -out root.crt
fi

if [ ! -f "intermediate.key" ]; then

    # Generate Intermediate Key
    echo "Generate Intermediate Key"
    openssl genrsa -out intermediate.key 4096
fi

if [ ! -f "intermediate.csr" ]; then

    echo "Generate Intermediate CSR"
    openssl req -new -key intermediate.key -config intermediate.conf -out intermediate.csr
fi

if [ ! -f "intermediate.crt" ]; then

    echo "Sign Intermediate with Root"
    openssl x509 -req -in intermediate.csr -CA root.crt -CAkey root.key \
    -CAcreateserial -out intermediate.crt -days 1825 -sha256 \
    -extfile intermediate.conf -extensions v3_intermediate_ca
fi

if [ ! -f "$COMMON_NAME.key" ]; then
    echo "Generate Leaf Key"
    openssl genrsa -out $COMMON_NAME.key 2048
fi

if [ ! -f "leaf.csr" ]; then

    echo "Generate Leaf CSR"
    openssl req -new -key $COMMON_NAME.key -config leaf.conf -out leaf.csr
fi

if [ ! -f "$COMMON_NAME.crt" ]; then

    echo "Sign Leaf with Intermediate"
    openssl x509 -req -in leaf.csr -CA intermediate.crt -CAkey intermediate.key \
    -CAcreateserial -out leaf.crt -days 365 -sha256 \
    -extfile leaf.conf -extensions v3_req

    echo "Generate full chain certificate for $COMMON_NAME"
    cat leaf.crt intermediate.crt > $COMMON_NAME.crt
fi


