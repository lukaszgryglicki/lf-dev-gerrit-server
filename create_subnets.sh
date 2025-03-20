#!/bin/bash
. ./env.sh
if [ ! -f "vpc.json.${STAGE}.secret" ]
then
  echo "$0: cannot find vpc.json.${STAGE}.secret"
  exit 1
fi
vpcid=$(cat vpc.json.${STAGE}.secret | jq -r '.Vpc.VpcId')
echo "VPC id: ${vpcid}"
if [ -z "${vpcid}" ]
then
  echo "$0: cannot fine VPC id"
  exit 2
fi
n=1
for z in a b c d e f
do
  if [ ! -f "subnet-1${z}.json.${STAGE}.secret" ]
  then
    aws --profile lfproduct-${STAGE} ec2 create-subnet --vpc-id "${vpcid}" --cidr-block "10.0.${n}.0/24" --availability-zone "us-east-1${z}" --tag-specifications "ResourceType=subnet,Tags=[{Key=Name,Value=${STAGE}_gerrit_subnet_us_east_1${z}}]" > "subnet-1${z}.json.${STAGE}.secret"
    res=$?
    if [ ! "${res}" = "0" ]
    then
      echo "$0: create subnet failed"
      rm -f "subnet-1${z}.json.${STAGE}.secret"
      continue
    fi
    subnetid=$(cat "subnet-1${z}.json.${STAGE}.secret" | jq -r '.Subnet.SubnetId')
    echo "subnet us-east-1${z} id: ${subnetid}"
    n=$((n+1))
  else
    echo "$0: subnet us-east-1${z} already created:"
    cat "subnet-1${z}.json.${STAGE}.secret"
  fi
done
