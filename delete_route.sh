#!/bin/bash
. ./env.sh
rtid=$(cat route-table.json.${STAGE}.secret | jq -r '.RouteTable.RouteTableId')
if [ ! -z "${rtid}" ]
then
  echo "route table id: ${rtid}"
  aws --profile lfproduct-${STAGE} ec2 delete-route --route-table-id "${rtid}" --destination-cidr-block 0.0.0.0/0
  res=$?
  if [ "${res}" = "0" ]
  then
    rm -f route.json.${STAGE}.secret
  else
    echo "delete result: ${res}"
  fi
else
  echo "$0: no route-table.json.${STAGE}.secret file"
fi
