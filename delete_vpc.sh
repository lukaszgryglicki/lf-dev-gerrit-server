#!/bin/bash
. ./env.sh
vpcid=$(cat vpc.json.${STAGE}.secret | jq -r '.Vpc.VpcId')
if [ ! -z "${vpcid}" ]
then
  echo "VPC id: ${vpcid}"
  aws --profile lfproduct-${STAGE} ec2 delete-vpc --vpc-id "${vpcid}"
  res=$?
  if [ "${res}" = "0" ]
  then
    rm -f "vpc.json.${STAGE}.secret" "describe-vpc.json.${STAGE}.secret"
  else
    echo "delete result: ${res}"
  fi
else
  echo "$0: no vpc.json.${STAGE}.secret file"
fi
