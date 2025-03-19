#!/bin/bash
rname=$(cat role.json.secret | jq -r '.Role.RoleName')
if [ ! -z "${rname}" ]
then
  echo "role name: ${rname}"
  aws --profile lfproduct-dev iam delete-role --role-name "${rname}"
  res=$?
  if [ "${res}" = "0" ]
  then
    rm -f "role.json.secret"
  else
    echo "delete result: ${res}"
  fi
else
  echo "$0: no role.json.secret file"
fi
