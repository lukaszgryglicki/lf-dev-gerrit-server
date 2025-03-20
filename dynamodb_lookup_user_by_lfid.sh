#!/bin/bash
. ./env.sh
if [ -z "$1" ]
then
  echo "$0: you need to specify user LFID as a 1st parameter"
  exit 1
fi

aws --profile lfproduct-${STAGE} dynamodb query --table-name cla-${STAGE}-users --index-name lf-username-index --key-condition-expression "lf_username = :name" --expression-attribute-values "{\":name\":{\"S\":\"${1}\"}}" | jq -r '.'
