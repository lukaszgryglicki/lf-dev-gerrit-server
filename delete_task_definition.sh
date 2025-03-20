#!/bin/bash
. ./env.sh
deleted=""
for arn in $(./list_task_definitions.sh)
do
  echo "deleting task $arn"
  aws --profile lfproduct-${STAGE} ecs deregister-task-definition --task-definition "${arn}"
  res=$?
  if [ ! "${res}" = "0" ]
  then
    echo "failed to delete task arn: ${arn}, delete result: ${res}"
  else
    deleted="1"
  fi
done
if [ ! -z "${deleted}" ]
then
  rm -f task.json.${STAGE}.secret task.json
fi
