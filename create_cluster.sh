#!/bin/bash
if [ ! -f "cluster.json.secret" ]
then
  aws --profile lfproduct-dev ecs create-cluster --cluster-name dev_gerrit_cluster > cluster.json.secret
  res=$?
  if [ ! "${res}" = "0" ]
  then
    echo "$0: create cluster failed"
    rm -f "cluster.json.secret"
    exit 1
  fi
  clsarn=$(cat cluster.json.secret | jq -r '.cluster.clusterArn')
  echo "cluster arn: ${clsarn}"
else
  echo "$0: cluster already created:"
  cat cluster.json.secret
fi
