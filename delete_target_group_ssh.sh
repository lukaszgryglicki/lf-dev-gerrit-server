#!/bin/bash
. ./env.sh
tgid=$(cat target-group-ssh.json.${STAGE}.secret | jq -r '.TargetGroups[].TargetGroupArn')
if [ ! -z "${tgid}" ]
then
  echo "ssh target group arn: ${tgid}"
  aws --profile lfproduct-${STAGE} elbv2 delete-target-group --target-group-arn "${tgid}"
  res=$?
  if [ "${res}" = "0" ]
  then
    rm -f "target-group-ssh.json.${STAGE}.secret"
  else
    echo "delete result: ${res}"
  fi
else
  echo "$0: no target-group-ssh.json.${STAGE}.secret file"
fi
