#!/bin/bash
. ./env.sh
if [ -z "$1" ]
then
  echo "$0: missing gerrit_id"
  exit 1
fi
aws --profile lfproduct-${STAGE} dynamodb get-item --table-name cla-${STAGE}-gerrit-instances --key "{\"gerrit_id\": {\"S\": \"${1}\"}}"
