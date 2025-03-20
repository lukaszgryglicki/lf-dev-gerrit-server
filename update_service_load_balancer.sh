#!/bin/bash
. ./env.sh
task="$(aws --profile lfproduct-${STAGE} ecs list-task-definitions --family-prefix ${STAGE}-gerrit-service | jq -r '.taskDefinitionArns[]')"
if [ -z "${task}" ]
then
  echo "$0: cannot find task"
  exit 1
fi
echo "task: ${task}"
tg=$(cat target-group.json.${STAGE}.secret | jq -r '.TargetGroups[].TargetGroupArn')
if [ -z "${tg}" ]
then
  echo "$0: target group not found"
  exit 2
fi
echo "target group http: ${tg}"
tg2=$(cat target-group-ssh.json.${STAGE}.secret | jq -r '.TargetGroups[].TargetGroupArn')
if [ -z "${tg2}" ]
then
  echo "$0: target group not found"
  exit 2
fi
echo "target group ssh: ${tg2}"
aws --profile lfproduct-${STAGE} ecs update-service --cluster ${STAGE}_gerrit_cluster --service ${STAGE}_gerrit_service --load-balancers targetGroupArn=${tg},containerName=${STAGE}_gerrit_main,containerPort=8080 targetGroupArn=${tg2},containerName=${STAGE}_gerrit_main,containerPort=29418 --force-new-deployment --deployment-configuration minimumHealthyPercent=0,maximumPercent=100
