#!/bin/bash
if [ -z "$1" ]
then
  echo "$0: missing 1st argument gerrit_id"
  exit 1
fi
if [ -z "$2" ]
then
  echo "$0: missing 2nd argument gerrit_name"
  exit 2
fi
if [ -z "$3" ]
then
  echo "$0: missing 2nd argument gerrit_url"
  exit 3
fi
aws --profile lfproduct-dev dynamodb update-item --table-name "cla-dev-gerrit-instances" --key "{\"gerrit_id\":{\"S\":\"${1}\"}}" --update-expression "SET gerrit_name = :gerrit_name" --expression-attribute-values "{\":gerrit_name\":{\"S\":\"${2}\"}}"
aws --profile lfproduct-dev dynamodb update-item --table-name "cla-dev-gerrit-instances" --key "{\"gerrit_id\":{\"S\":\"${1}\"}}" --update-expression "SET gerrit_url = :gerrit_url" --expression-attribute-values "{\":gerrit_url\":{\"S\":\"${3}\"}}"
