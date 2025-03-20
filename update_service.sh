#!/bin/bash
. ./env.sh
task="$(aws --profile lfproduct-${STAGE} ecs list-task-definitions --family-prefix ${STAGE}-gerrit-service | jq -r '.taskDefinitionArns[]')"
if [ -z "${task}" ]
then
  echo "$0: cannot find task"
  exit 1
fi
aws --profile lfproduct-${STAGE} ecs update-service --cluster ${STAGE}_gerrit_cluster --service ${STAGE}_gerrit_service --task-definition "${task}" --enable-execute-command --deployment-configuration minimumHealthyPercent=0,maximumPercent=100
