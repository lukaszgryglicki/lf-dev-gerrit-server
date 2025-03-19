#!/bin/bash
if [ -z "$1" ]
then
  echo "$0: missing gerrit_id"
  exit 1
fi
aws --profile lfproduct-dev dynamodb get-item --table-name cla-dev-gerrit-instances --key "{\"gerrit_id\": {\"S\": \"${1}\"}}"
