#!/bin/bash
if [ -z "$1" ]
then
  echo "$0: you need to specify signature_id as a 1st parameter, for example: '6168fc0b-705a-4fde-a9dd-d0a4a9c01457'"
  exit 1
fi

aws --profile "lfproduct-dev" dynamodb delete-item --table-name "cla-dev-signatures" --key "{\"signature_id\":{\"S\":\"${1}\"}}"
