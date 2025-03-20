#!/bin/bash
. ./env.sh
# PROJECTS=1
if [ -z "$1" ]
then
  echo "$0: missing cla_group_id"
  exit 1
fi
if [ -z "${PROJECTS}" ]
then
  aws --profile lfproduct-${STAGE} dynamodb scan --table-name cla-${STAGE}-projects-cla-groups --filter-expression "cla_group_id = :value" --expression-attribute-values "{\":value\":{\"S\":\"${1}\"}}"
else
  aws --profile lfproduct-${STAGE} dynamodb scan --table-name cla-${STAGE}-projects-cla-groups --filter-expression "cla_group_id = :value" --expression-attribute-values "{\":value\":{\"S\":\"${1}\"}}" | jq -r '.Items[] | "\(.project_sfid.S): \(.project_name.S)"'
fi
