#!/bin/bash
. ./env.sh
rname=$(cat role.json.${STAGE}.secret | jq -r '.Role.RoleName')
if [ ! -z "${rname}" ]
then
  echo "role name: ${rname}"
  aws --profile lfproduct-${STAGE} iam delete-role --role-name "${rname}"
  res=$?
  if [ "${res}" = "0" ]
  then
    rm -f "role.json.${STAGE}.secret"
  else
    echo "delete result: ${res}"
  fi
else
  echo "$0: no role.json.${STAGE}.secret file"
fi
