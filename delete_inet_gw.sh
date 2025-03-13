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
igwid=$(cat inet-gw.json.secret | jq -r '.InternetGateway.InternetGatewayId')
if [ ! -z "${igwid}" ]
then
  echo "inet-gw id: ${igwid}"
  if [ ! -z "${vpcid}" ]
  then
    aws --profile lfproduct-dev ec2 detach-internet-gateway --internet-gateway-id "${igwid}" --vpc-id "${vpcid}"
  fi
  aws --profile lfproduct-dev ec2 delete-internet-gateway --internet-gateway-id "${igwid}"
  res=$?
  if [ "${res}" = "0" ]
  then
    rm -f "inet-gw.json.secret" "describe-inet-gw.json.secret"
  else
    echo "delete result: ${res}"
  fi
else
  echo "$0: no inet-gw.json.secret file"
fi
