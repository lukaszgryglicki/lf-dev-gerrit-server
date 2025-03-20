#!/bin/bash
. ./env.sh
domain="$(cat ./domain.${STAGE}.secret)"
url="https://${domain}/"
usr=$(cat ./username.${STAGE}.secret)
token=$(cat ./http-token.${STAGE}.secret)
# echo "curl -s -u ${usr}:${token} ${url}a/groups/"
curl -s -u "${usr}:${token}" "${url}a/groups/" | sed "s/)]}'//" | jq -r '.'
