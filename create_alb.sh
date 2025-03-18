#!/bin/bash
if [ ! -f "alb.json.secret" ]
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
      subnets="${subnets} ${subnetid}"
    fi
  done
  echo "subnets: ${subnets}"
  aws --profile lfproduct-dev elbv2 create-load-balancer --name "dev-gerrit-alb" --subnets ${subnets} --security-groups "${sgid}" --scheme internet-facing --type application --ip-address-type ipv4 > alb.json.secret
  res=$?
  if [ ! "${res}" = "0" ]
  then
    echo "$0: create ALB failed"
    rm -f "alb.json.secret"
    exit 1
  fi
  alb=$(cat alb.json.secret | jq -r '.LoadBalancers[].LoadBalancerArn')
  echo "ALB: ${alb}"
else
  echo "$0: ALB already created:"
  cat alb.json.secret
fi
