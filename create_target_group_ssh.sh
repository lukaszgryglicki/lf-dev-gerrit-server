#!/bin/bash
. ./env.sh
vpcid=$(cat vpc.json.${STAGE}.secret | jq -r '.Vpc.VpcId')
echo "VPC id: ${vpcid}"
if [ -z "${vpcid}" ]
then
  echo "$0: no VPC found"
  exit 1
fi
if [ ! -f "target-group-ssh.json.${STAGE}.secret" ]
then
  aws --profile lfproduct-${STAGE} elbv2 create-target-group --name "${STAGE}-gerrit-target-group-ssh" --protocol TCP --port 29418 --target-type ip --vpc-id "${vpcid}" > target-group-ssh.json.${STAGE}.secret
  res=$?
  if [ ! "${res}" = "0" ]
  then
    echo "$0: create target group failed"
    rm -f "target-group-ssh.json.${STAGE}.secret"
    exit 2
  fi
  tgid=$(cat target-group-ssh.json.${STAGE}.secret | jq -r '.TargetGroups[].TargetGroupArn')
  echo "target group arn: ${tgid}"
else
  echo "$0: target group already created:"
  cat target-group-ssh.json.${STAGE}.secret
fi
