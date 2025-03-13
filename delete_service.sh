#!/bin/bash
svcid=$(cat service.json.secret | jq -r '.service.serviceArn')
if [ -z "${svcid}" ]
then
  echo "$0: cannot find service"
  exit 1
fi
echo "service id: ${svcid}"
aws --profile lfproduct-dev ecs delete-service --cluster dev_gerrit_cluster --service "${svcid}" --force > /dev/null
res=$?
if [ "${res}" = "0" ]
then
  rm -f "service.json.secret"
else
  echo "delete result: ${res}"
fi
