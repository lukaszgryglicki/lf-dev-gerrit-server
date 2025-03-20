#!/bin/bash
if [ -z "$1" ]
then
  echo "$0: you need to specify signature_id as a 1st parameter, for example: '6168fc0b-705a-4fde-a9dd-d0a4a9c01457'"
  exit 1
fi

aws --profile "lfproduct-dev" dynamodb query --table-name "cla-dev-signatures" --key-condition-expression "signature_id = :signature_id" --expression-attribute-values "{\":signature_id\":{\"S\":\"${1}\"}}" | jq -r '.'
