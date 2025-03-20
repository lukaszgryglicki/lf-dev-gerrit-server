#!/bin/bash
. ./env.sh
svcid=$(cat service.json.${STAGE}.secret | jq -r '.service.serviceArn')
if [ -z "${svcid}" ]
then
  echo "$0: cannot find service"
  exit 1
fi
echo "service id: ${svcid}"
aws --profile lfproduct-${STAGE} ecs delete-service --cluster ${STAGE}_gerrit_cluster --service "${svcid}" --force
res=$?
if [ "${res}" = "0" ]
then
  rm -f "service.json.${STAGE}.secret"
else
  echo "delete result: ${res}"
fi
