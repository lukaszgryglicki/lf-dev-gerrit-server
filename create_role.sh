#!/bin/bash
if [ ! -f "role.json.secret" ]
then
  aws --profile lfproduct-dev iam create-role --role-name ecsTaskRoleForExec --assume-role-policy-document '{
    "Version": "2012-10-17",
    "Statement": [{
        "Effect": "Allow",
        "Principal": {
          "Service": "ecs-tasks.amazonaws.com"
        },
        "Action": "sts:AssumeRole"
    }]
  }' > role.json.secret
  res=$?
  if [ ! "${res}" = "0" ]
  then
    echo "$0: create role failed"
    rm -f "role.json.secret"
    exit 1
  fi
  rname=$(cat role.json.secret | jq -r '.Role.RoleName')
  echo "role name: ${rname}"
  aws --profile lfproduct-dev iam attach-role-policy --role-name "${rname}" --policy-arn arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore
  res=$?
  if [ ! "${res}" = "0" ]
  then
    echo "$0: attach role policy failed"
    exit 2
  fi
  aws --profile lfproduct-dev iam get-role --role-name "${rname}"
  aws --profile lfproduct-dev iam list-attached-role-policies --role-name "${rname}"
else
  echo "$0: role already created:"
  cat role.json.secret
fi
