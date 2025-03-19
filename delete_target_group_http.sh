#!/bin/bash
tgid=$(cat target-group.json.secret | jq -r '.TargetGroups[].TargetGroupArn')
if [ ! -z "${tgid}" ]
then
  echo "target group arn: ${tgid}"
  aws --profile lfproduct-dev elbv2 delete-target-group --target-group-arn "${tgid}"
  res=$?
  if [ "${res}" = "0" ]
  then
    rm -f "target-group.json.secret"
  else
    echo "delete result: ${res}"
  fi
else
  echo "$0: no target-group.json.secret file"
fi
