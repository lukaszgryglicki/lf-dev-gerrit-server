#!/bin/bash
. ./env.sh
# internal net is 10.0.0.0/16, outside world facing is 0.0.0.0/0
if [ ! -f "security-group.json.${STAGE}.secret" ]
then
  vpcid=$(cat vpc.json.${STAGE}.secret | jq -r '.Vpc.VpcId')
  if [ -z "${vpcid}" ]
  then
    echo "$0:cannot find VPC id"
    exit 1
  fi
  echo "VPC id: ${vpcid}"
  aws --profile lfproduct-${STAGE} ec2 create-security-group --group-name dev_gerrit_security_group --description "Security Group for Dev Gerrit EFS" --vpc-id "${vpcid}" --tag-specifications 'ResourceType=security-group,Tags=[{Key=Name,Value=dev_gerrit_security_group}]' > security-group.json.${STAGE}.secret
  res=$?
  if [ ! "${res}" = "0" ]
  then
    echo "$0: create security group failed"
    rm -f "security-group.json.${STAGE}.secret"
    exit 2
  fi
  sgid=$(cat security-group.json.${STAGE}.secret | jq -r '.GroupId')
  echo "security group id: ${sgid}"
  aws --profile lfproduct-${STAGE} ec2 authorize-security-group-ingress --group-id "${sgid}" --protocol tcp --port 2049 --cidr 10.0.0.0/16 > security-group-ingress.json.${STAGE}.secret
  res=$?
  if [ ! "${res}" = "0" ]
  then
    echo "$0: create authorize security group ingress failed"
    rm -f "security-group-ingress.json.${STAGE}.secret"
    exit 3
  fi
  aws --profile lfproduct-${STAGE} ec2 authorize-security-group-ingress --group-id "${sgid}" --protocol tcp --port 29418 --cidr 0.0.0.0/0 >> security-group-ingress.json.${STAGE}.secret
  res=$?
  if [ ! "${res}" = "0" ]
  then
    echo "$0: create authorize security group ingress failed"
    rm -f "security-group-ingress.json.${STAGE}.secret"
    exit 4
  fi
  aws --profile lfproduct-${STAGE} ec2 authorize-security-group-ingress --group-id "${sgid}" --protocol tcp --port 2222 --cidr 0.0.0.0/0 >> security-group-ingress.json.${STAGE}.secret
  res=$?
  if [ ! "${res}" = "0" ]
  then
    echo "$0: create authorize security group ingress failed"
    rm -f "security-group-ingress.json.${STAGE}.secret"
    exit 5
  fi
  aws --profile lfproduct-${STAGE} ec2 authorize-security-group-ingress --group-id "${sgid}" --protocol tcp --port 8080 --cidr 0.0.0.0/0 >> security-group-ingress.json.${STAGE}.secret
  res=$?
  if [ ! "${res}" = "0" ]
  then
    echo "$0: create authorize security group ingress failed"
    rm -f "security-group-ingress.json.${STAGE}.secret"
    exit 6
  fi
  aws --profile lfproduct-${STAGE} ec2 authorize-security-group-ingress --group-id "${sgid}" --protocol tcp --port 443 --cidr 0.0.0.0/0 >> security-group-ingress.json.${STAGE}.secret
  res=$?
  if [ ! "${res}" = "0" ]
  then
    echo "$0: create authorize security group ingress failed"
    rm -f "security-group-ingress.json.${STAGE}.secret"
    exit 7
  fi
  aws --profile lfproduct-${STAGE} ec2 authorize-security-group-ingress --group-id "${sgid}" --protocol tcp --port 80 --cidr 0.0.0.0/0 >> security-group-ingress.json.${STAGE}.secret
  res=$?
  if [ ! "${res}" = "0" ]
  then
    echo "$0: create authorize security group ingress failed"
    rm -f "security-group-ingress.json.${STAGE}.secret"
    exit 8
  fi
  aws --profile lfproduct-${STAGE} ec2 describe-security-groups --filters "Name=group-name,Values=dev_gerrit_security_group" > describe-security-group.json.${STAGE}.secret
  res=$?
  if [ ! "${res}" = "0" ]
  then
    echo "$0: create describe security groups failed"
    rm -f "describe-security-group.json.${STAGE}.secret"
    exit 9
  fi
else
  echo "$0: security group already created:"
  cat security-group.json.${STAGE}.secret
  cat security-group-ingress.json.${STAGE}.secret
  cat describe-security-group.json.${STAGE}.secret
fi
