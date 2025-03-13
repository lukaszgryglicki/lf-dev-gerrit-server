#!/bin/bash
if [ ! -f "service.json.secret" ]
then
  sgid=$(cat security-group.json.secret | jq -r '.GroupId')
  if [ -z "${sgid}" ]
  then
    echo "$0: no security group id found"
    exit 1
  fi
  echo "security group ID: ${sgid}"
  subnets=""
  for z in a b c d e f
  do
    if [ ! -f "subnet-1${z}.json.secret" ]
    then
      echo "subnet configuration for us-east-1${z} not found, skipping"
      continue
    fi
    subnetid=$(cat "subnet-1${z}.json.secret" | jq -r '.Subnet.SubnetId')
    if [ -z "${subnetid}" ]
    then
      echo "subnet ID for us-east-1${z} not found, skipping"
      continue
    fi
    echo "subnet us-east-1${z} id: ${subnetid}"
    if [ -z "${subnets}" ]
    then
      subnets="${subnetid}"
    else
      subnets="${subnets},${subnetid}"
    fi
  done
  netconf="awsvpcConfiguration={subnets=[${subnets}],securityGroups=[${sgid}],assignPublicIp=\"ENABLED\"}" > service.json.secret
  aws --profile lfproduct-dev ecs create-service --cluster dev_gerrit_cluster --service-name dev_gerrit_service --task-definition dev-gerrit-service --desired-count 1 --launch-type FARGATE --network-configuration "$netconf" > service.json.secret
  res=$?
  if [ ! "${res}" = "0" ]
  then
    echo "$0: create service failed"
    rm -f "service.json.secret"
    exit 1
  fi
  svcid=$(cat service.json.secret | jq -r '.service.serviceArn')
  echo "service id: ${svcid}"
else
  echo "$0: service already created:"
  cat service.json.secret
fi
