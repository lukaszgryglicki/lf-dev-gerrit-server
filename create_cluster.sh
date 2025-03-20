#!/bin/bash
. ./env.sh
if [ ! -f "cluster.json.${STAGE}.secret" ]
then
  aws --profile lfproduct-${STAGE} ecs create-cluster --cluster-name dev_gerrit_cluster > cluster.json.${STAGE}.secret
  res=$?
  if [ ! "${res}" = "0" ]
  then
    echo "$0: create cluster failed"
    rm -f "cluster.json.${STAGE}.secret"
    exit 1
  fi
  clsarn=$(cat cluster.json.${STAGE}.secret | jq -r '.cluster.clusterArn')
  echo "cluster arn: ${clsarn}"
else
  echo "$0: cluster already created:"
  cat cluster.json.${STAGE}.secret
fi
