#!/bin/bash
. ./env.sh
task="$(aws --profile lfproduct-${STAGE} ecs list-tasks --cluster ${STAGE}_gerrit_cluster | jq -r '.taskArns[]')"
if [ -z "${task}" ]
then
  echo "$0: task not found"
  exit 1
fi
echo "task: ${task}"
aws --profile lfproduct-${STAGE} ecs execute-command --cluster ${STAGE}_gerrit_cluster --task "${task}" --container ${STAGE}_gerrit_main --interactive --command "/bin/sh"
