#!/bin/bash
for arn in $(./list_tasks.sh)
do
  echo "deleting task $arn"
  aws --profile lfproduct-dev ecs deregister-task-definition --task-definition "${arn}" > /dev/null
  res=$?
  if [ ! "${res}" = "0" ]
  then
    echo "failed to delete task arn: ${arn}, delete result: ${res}"
  fi
done
