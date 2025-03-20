#!/bin/bash
. ./env.sh
clsarn=$(cat cluster.json.${STAGE}.secret | jq -r '.cluster.clusterArn')
if [ ! -z "${clsarn}" ]
then
  echo "cluster arn: ${clsarn}"
  aws --profile lfproduct-${STAGE} ecs delete-cluster --cluster "${clsarn}"
  res=$?
  if [ "${res}" = "0" ]
  then
    rm -f "cluster.json.${STAGE}.secret"
  else
    echo "delete result: ${res}"
  fi
else
  echo "$0: no cluster.json.${STAGE}.secret file"
fi
