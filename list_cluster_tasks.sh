#!/bin/bash
aws --profile lfproduct-dev ecs list-tasks --cluster dev_gerrit_cluster | jq -r '.'
for task in $(aws --profile lfproduct-dev ecs list-tasks --cluster dev_gerrit_cluster | jq -r '.taskArns[]')
do
  echo "task: $task"
  aws --profile lfproduct-dev ecs describe-tasks --cluster dev_gerrit_cluster --tasks "arn:aws:ecs:us-east-1:395594542180:task/dev_gerrit_cluster/1f217a4f6c25400abc20ae868e38dd22" | jq -r '.'
done
