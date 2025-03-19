#!/bin/bash
task="$(aws --profile lfproduct-dev ecs list-tasks --cluster dev_gerrit_cluster | jq -r '.taskArns[]')"
if [ -z "${task}" ]
then
  echo "$0: task not found"
  exit 1
fi
echo "task: ${task}"
aws --profile lfproduct-dev ecs execute-command --cluster dev_gerrit_cluster --task "${task}" --container dev_gerrit_main --interactive --command "/bin/sh"
