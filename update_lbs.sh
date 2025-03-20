#!/bin/bash
. ./env.sh
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
aws --profile lfproduct-${STAGE} ecs update-service --cluster dev_gerrit_cluster --service dev_gerrit_service --load-balancers targetGroupArn=${tg},containerName=dev_gerrit_main,containerPort=8080 targetGroupArn=${tg2},containerName=dev_gerrit_main,containerPort=29418 --deployment-configuration minimumHealthyPercent=0,maximumPercent=100
