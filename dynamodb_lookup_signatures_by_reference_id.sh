#!/bin/bash
. ./env.sh
if [ -z "$1" ]
then
  echo "$0: you need to specify reference_id as a 1st parameter"
  exit 1
fi
aws --profile "lfproduct-${STAGE}" dynamodb query --table-name "cla-${STAGE}-signatures" --index-name reference-signature-index --key-condition-expression "signature_reference_id = :reference_id" --expression-attribute-values "{\":reference_id\":{\"S\":\"${1}\"}}" | jq -r '.'
