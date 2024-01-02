#!/bin/bash
# get-thumbprint.sh

OIDC_URL=$1
HOST=$(echo $OIDC_URL | awk -F/ '{print $3}')
THUMBPRINT=$(echo | openssl s_client -servername $HOST -showcerts -connect $HOST:443 2>/dev/null | openssl x509 -fingerprint -noout | cut -d'=' -f2 | tr -d ':')

echo "{\"thumbprint\":\"$THUMBPRINT\"}"
