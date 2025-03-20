#!/bin/bash
. ./env.sh
if [ ! -f "nlb.json.${STAGE}.secret" ]
then
  subnets=""
  for z in a b c d e f
  do
    if [ ! -f "subnet-1${z}.json.${STAGE}.secret" ]
    then
      echo "subnet configuration for us-east-1${z} not found, skipping"
      continue
    fi
    subnetid=$(cat "subnet-1${z}.json.${STAGE}.secret" | jq -r '.Subnet.SubnetId')
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
  aws --profile lfproduct-${STAGE} elbv2 create-load-balancer --name "${STAGE}-gerrit-nlb" --subnets ${subnets} --scheme internet-facing --type network --ip-address-type ipv4 > nlb.json.${STAGE}.secret
  res=$?
  if [ ! "${res}" = "0" ]
  then
    echo "$0: create NLB failed"
    rm -f "nlb.json.${STAGE}.secret"
    exit 1
  fi
  nlb=$(cat nlb.json.${STAGE}.secret | jq -r '.LoadBalancers[].LoadBalancerArn')
  echo "NLB: ${nlb}"
else
  echo "$0: NLB already created:"
  cat nlb.json.${STAGE}.secret
fi
