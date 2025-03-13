#!/bin/bash
sgid=$(cat security-group.json.secret | jq -r '.GroupId')
if [ ! -z "${sgid}" ]
then
  echo "security group id: ${sgid}"
  aws --profile lfproduct-dev ec2 delete-security-group --group-id "${sgid}"
  res=$?
  if [ "${res}" = "0" ]
  then
    rm -f "security-group.json.secret" "describe-security-group.json.secret" "security-group-ingress.json.secret"
  else
    echo "delete result: ${res}"
  fi
else
  echo "$0: no security-group.json.secret file"
fi
