#!/bin/bash
vpcid=$(cat vpc.json.secret | jq -r '.Vpc.VpcId')
if [ ! -z "${vpcid}" ]
then
  echo "VPC id: ${vpcid}"
  aws --profile lfproduct-dev ec2 delete-vpc --vpc-id "${vpcid}"
  res=$?
  if [ "${res}" = "0" ]
  then
    rm -f "vpc.json.secret"
  else
    echo "delete result: ${res}"
  fi
else
  echo "$0: no vpc.json.secret file"
fi
