#!/bin/bash
# NOVPC - allow no VPC but in such case you need to manually connect inet gateway to VPC that you create later
vpcid=$(cat vpc.json.secret | jq -r '.Vpc.VpcId')
echo "VPC id: ${vpcid}"
if [ -z "${vpcid}" ]
then
  if [ ! -z "$NOVPC" ]
  then
    echo "$0: you should create VPC first"
  else
    echo "$0: no VPC found"
    exit 1
  fi
fi
if [ ! -f "inet-gw.json.secret" ]
then
  aws --profile lfproduct-dev ec2 create-internet-gateway --tag-specifications 'ResourceType=internet-gateway,Tags=[{Key=Name,Value=dev_gerrit_internet_gw}]' > inet-gw.json.secret
  res=$?
  if [ ! "${res}" = "0" ]
  then
    echo "$0: create inet gw failed"
    rm -f "inet-gw.json.secret"
    exit 2
  fi
  igwid=$(cat inet-gw.json.secret | jq -r '.InternetGateway.InternetGatewayId')
  echo "inet-gw id: ${igwid}"
  if [ ! -z "${vpcid}" ]
  then
    aws --profile lfproduct-dev ec2 attach-internet-gateway --internet-gateway-id "${igwid}" --vpc-id "${vpcid}"
    res=$?
    if [ ! "${res}" = "0" ]
    then
      echo "$0: attach inet gw failed"
    fi
  fi
  aws --profile lfproduct-dev ec2 describe-internet-gateways --internet-gateway-id "${igwid}" > describe-inet-gw.json.secret
  res=$?
  if [ ! "${res}" = "0" ]
  then
    echo "$0: describe inet gw failed"
    rm -f "describe-inet-gw.json.secret"
  fi
else
  echo "$0: inet-gw already created:"
  cat inet-gw.json.secret
  cat describe-inet-gw.json.secret
fi
