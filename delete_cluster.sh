#!/bin/bash
clsarn=$(cat cluster.json.secret | jq -r '.cluster.clusterArn')
if [ ! -z "${clsarn}" ]
then
  echo "cluster arn: ${clsarn}"
  aws --profile lfproduct-dev ecs delete-cluster --cluster "${clsarn}"
  res=$?
  if [ "${res}" = "0" ]
  then
    rm -f "cluster.json.secret"
  else
    echo "delete result: ${res}"
  fi
else
  echo "$0: no cluster.json.secret file"
fi
