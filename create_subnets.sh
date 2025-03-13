#!/bin/bash
if [ ! -f "vpc.json.secret" ]
then
  echo "$0: cannot find vpc.json.secret"
  exit 1
fi
vpcid=$(cat vpc.json.secret | jq -r '.Vpc.VpcId')
echo "VPC id: ${vpcid}"
if [ -z "${vpcid}" ]
then
  echo "$0: cannot fine VPC id"
  exit 2
fi
n=1
for z in a b c d e f
do
  if [ ! -f "subnet-1${z}.json.secret" ]
  then
    aws --profile lfproduct-dev ec2 create-subnet --vpc-id "${vpcid}" --cidr-block "10.0.${n}.0/24" --availability-zone "us-east-1${z}" --tag-specifications "ResourceType=subnet,Tags=[{Key=Name,Value=dev_gerrit_subnet_us_east_1${z}}]" > "subnet-1${z}.json.secret"
    subnetid=$(cat "subnet-1${z}.json.secret" | jq -r '.Subnet.SubnetId')
    echo "Subnet us-east-1${z} id: ${subnetid}"
    n=$((n+1))
  else
    echo "$0: subnet us-east-1${z} already created:"
    cat "subnet-1${z}.json.secret"
  fi
done
