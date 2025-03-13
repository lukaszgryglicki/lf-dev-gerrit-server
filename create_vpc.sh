#!/bin/bash
if [ ! -f "vpc.json.secret" ]
then
  aws --profile lfproduct-dev ec2 create-vpc --cidr-block 10.0.0.0/16 --tag-specifications 'ResourceType=vpc,Tags=[{Key=Name,Value=dev_gerrit_vpc}]' > vpc.json.secret
  res=$?
  if [ ! "${res}" = "0" ]
  then
    echo "$0: create vpc failed"
    rm -f "vpc.json.secret"
    exit 1
  fi
  vpcid=$(cat vpc.json.secret | jq -r '.Vpc.VpcId')
  echo "VPC id: ${vpcid}"
else
  echo "$0: VPC already created:"
  cat vpc.json.secret
fi
