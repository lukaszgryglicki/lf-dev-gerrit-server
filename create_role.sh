#!/bin/bash
. ./env.sh
if [ ! -f "role.json.${STAGE}.secret" ]
then
  aws --profile lfproduct-${STAGE} iam create-role --role-name ecsTaskRoleForExec --assume-role-policy-document '{
    "Version": "2012-10-17",
    "Statement": [{
        "Effect": "Allow",
        "Principal": {
          "Service": "ecs-tasks.amazonaws.com"
        },
        "Action": "sts:AssumeRole"
    }]
  }' > role.json.${STAGE}.secret
  res=$?
  if [ ! "${res}" = "0" ]
  then
    echo "$0: create role failed"
    rm -f "role.json.${STAGE}.secret"
    exit 1
  fi
  rname=$(cat role.json.${STAGE}.secret | jq -r '.Role.RoleName')
  echo "role name: ${rname}"
  aws --profile lfproduct-${STAGE} iam attach-role-policy --role-name "${rname}" --policy-arn arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore
  res=$?
  if [ ! "${res}" = "0" ]
  then
    echo "$0: attach role policy failed"
    exit 2
  fi
  aws --profile lfproduct-${STAGE} iam get-role --role-name "${rname}"
  aws --profile lfproduct-${STAGE} iam list-attached-role-policies --role-name "${rname}"
else
  echo "$0: role already created:"
  cat role.json.${STAGE}.secret
fi
