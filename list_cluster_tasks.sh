#!/bin/bash
aws --profile lfproduct-dev ecs list-tasks --cluster dev_gerrit_cluster | jq -r '.'
for task in $(aws --profile lfproduct-dev ecs list-tasks --cluster dev_gerrit_cluster | jq -r '.taskArns[]')
do
  echo "task: $task"
  aws --profile lfproduct-dev ecs describe-tasks --cluster dev_gerrit_cluster --tasks "${task}" | jq -r '.'
done
