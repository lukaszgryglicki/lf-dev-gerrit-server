#!/bin/bash
task="$(aws --profile lfproduct-dev ecs list-task-definitions --family-prefix dev-gerrit-service | jq -r '.taskDefinitionArns[]')"
if [ -z "${task}" ]
then
  echo "$0: cannot find task"
  exit 1
fi
echo "task: ${task}"
tg=$(cat target-group.json.secret | jq -r '.TargetGroups[].TargetGroupArn')
if [ -z "${tg}" ]
then
  echo "$0: target group not found"
  exit 2
fi
echo "target group: ${tg}"
aws --profile lfproduct-dev ecs update-service --cluster dev_gerrit_cluster --service dev_gerrit_service --load-balancers "targetGroupArn=${tg},containerName=dev_gerrit_main,containerPort=8080" --force-new-deployment
