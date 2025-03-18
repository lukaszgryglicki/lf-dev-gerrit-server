#!/bin/bash
vpcid=$(cat vpc.json.secret | jq -r '.Vpc.VpcId')
echo "VPC id: ${vpcid}"
if [ -z "${vpcid}" ]
then
  echo "$0: no VPC found"
  exit 1
fi
if [ ! -f "target-group.json.secret" ]
then
  aws --profile lfproduct-dev elbv2 create-target-group --name "dev-gerrit-target-group" --protocol HTTP --port 8080 --target-type ip --vpc-id "${vpcid}" --health-check-protocol HTTP --health-check-path / --health-check-port 8080 > target-group.json.secret
  # aws --profile lfproduct-dev elbv2 create-target-group --name "dev-gerrit-target-group" --protocol HTTP --port 8080 --target-type ip --vpc-id "${vpcid}" > target-group.json.secret
  res=$?
  if [ ! "${res}" = "0" ]
  then
    echo "$0: create target group failed"
    rm -f "target-group.json.secret"
    exit 2
  fi
  tgid=$(cat target-group.json.secret | jq -r '.TargetGroups[].TargetGroupArn')
  echo "target group arn: ${tgid}"
else
  echo "$0: target group already created:"
  cat target-group.json.secret
fi
