#!/bin/bash
. ./env.sh
if [ ! -f "vpc.json.${STAGE}.secret" ]
then
  aws --profile lfproduct-${STAGE} ec2 create-vpc --cidr-block 10.0.0.0/16 --tag-specifications 'ResourceType=vpc,Tags=[{Key=Name,Value=dev_gerrit_vpc}]' > vpc.json.${STAGE}.secret
  res=$?
  if [ ! "${res}" = "0" ]
  then
    echo "$0: create vpc failed"
    rm -f "vpc.json.${STAGE}.secret"
    exit 1
  fi
  vpcid=$(cat vpc.json.${STAGE}.secret | jq -r '.Vpc.VpcId')
  echo "VPC id: ${vpcid}"
  aws --profile lfproduct-${STAGE} ec2 modify-vpc-attribute --vpc-id "${vpcid}" --enable-dns-support "{\"Value\":true}"
  res=$?
  if [ ! "${res}" = "0" ]
  then
    echo "$0: update vpc failed"
    rm -f "vpc.json.${STAGE}.secret"
    exit 2
  fi
  aws --profile lfproduct-${STAGE} ec2 modify-vpc-attribute --vpc-id "${vpcid}" --enable-dns-hostnames "{\"Value\":true}"
  res=$?
  if [ ! "${res}" = "0" ]
  then
    echo "$0: update vpc failed"
    rm -f "vpc.json.${STAGE}.secret"
    exit 3
  fi
  aws --profile lfproduct-${STAGE} ec2 describe-vpcs --vpc-ids "${vpcid}" > describe-vpc.json.${STAGE}.secret
  res=$?
  if [ ! "${res}" = "0" ]
  then
    echo "$0: describe vpc failed"
  fi
else
  echo "$0: VPC already created:"
  cat vpc.json.${STAGE}.secret
  cat describe-vpc.json.${STAGE}.secret
fi
