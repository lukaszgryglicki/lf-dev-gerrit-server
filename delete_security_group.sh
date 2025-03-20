#!/bin/bash
. ./env.sh
sgid=$(cat security-group.json.${STAGE}.secret | jq -r '.GroupId')
if [ ! -z "${sgid}" ]
then
  echo "security group id: ${sgid}"
  aws --profile lfproduct-${STAGE} ec2 delete-security-group --group-id "${sgid}"
  res=$?
  if [ "${res}" = "0" ]
  then
    rm -f "security-group.json.${STAGE}.secret" "describe-security-group.json.${STAGE}.secret" "security-group-ingress.json.${STAGE}.secret"
  else
    echo "delete result: ${res}"
  fi
else
  echo "$0: no security-group.json.${STAGE}.secret file"
fi
