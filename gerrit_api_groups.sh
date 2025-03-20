#!/bin/bash
url='https://gerrit.dev.platform.linuxfoundation.org/'
usr=$(cat ./username.secret)
token=$(cat ./http-token.secret)
echo "curl -s -u ${usr}:${token} ${url}a/groups/"
curl -s -u "${usr}:${token}" "${url}a/groups/" | sed "s/)]}'//" | jq -r '.'
