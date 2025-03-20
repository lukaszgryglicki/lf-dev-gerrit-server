#!/bin/bash
. ./env.sh
if [ -z "$VERBOSE" ]
then
  aws --profile lfproduct-${STAGE} ecs list-task-definitions --family-prefix ${STAGE}-gerrit-service | jq -r '.taskDefinitionArns[]'
else
  aws --profile lfproduct-${STAGE} ecs list-task-definitions --family-prefix ${STAGE}-gerrit-service | jq -r
fi
