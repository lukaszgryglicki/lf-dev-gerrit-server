#!/bin/bash
. ./env.sh
aws --profile lfproduct-${STAGE} ecs list-tasks --cluster dev_gerrit_cluster | jq -r '.'
for task in $(aws --profile lfproduct-${STAGE} ecs list-tasks --cluster dev_gerrit_cluster | jq -r '.taskArns[]')
do
  echo "task: $task"
  aws --profile lfproduct-${STAGE} ecs describe-tasks --cluster dev_gerrit_cluster --tasks "${task}" | jq -r '.'
done
