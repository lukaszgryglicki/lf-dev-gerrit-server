#!/bin/bash
if [ ! -f "security-group.json.secret" ]
then
  vpcid=$(cat vpc.json.secret | jq -r '.Vpc.VpcId')
  if [ -z "${vpcid}" ]
  then
    echo "$0:cannot find VPC id"
    exit 1
  fi
  echo "VPC id: ${vpcid}"
  aws --profile lfproduct-dev ec2 create-security-group --group-name dev_gerrit_security_group --description "Security Group for Dev Gerrit EFS" --vpc-id "${vpcid}" --tag-specifications 'ResourceType=security-group,Tags=[{Key=Name,Value=dev_gerrit_security_group}]' > security-group.json.secret
  res=$?
  if [ ! "${res}" = "0" ]
  then
    echo "$0: create security group failed"
    rm -f "security-group.json.secret"
    exit 2
  fi
  sgid=$(cat security-group.json.secret | jq -r '.GroupId')
  echo "security group id: ${sgid}"
  aws --profile lfproduct-dev ec2 authorize-security-group-ingress --group-id "${sgid}" --protocol tcp --port 2049 --cidr 10.0.0.0/16 > security-group-ingress.json.secret
  res=$?
  if [ ! "${res}" = "0" ]
  then
    echo "$0: create authorize security group ingress failed"
    rm -f "security-group-ingress.json.secret"
    exit 3
  fi
  aws --profile lfproduct-dev ec2 describe-security-groups --filters "Name=group-name,Values=dev_gerrit_security_group" > describe-security-group.json.secret
  res=$?
  if [ ! "${res}" = "0" ]
  then
    echo "$0: create describe security groups failed"
    rm -f "describe-security-group.json.secret"
    exit 4
  fi
else
  echo "$0: security group already created:"
  cat security-group.json.secret
  cat security-group-ingress.json.secret
  cat describe-security-group.json.secret
fi
