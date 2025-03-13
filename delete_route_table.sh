#!/bin/bash
rtid=$(cat route-table.json.secret | jq -r '.RouteTable.RouteTableId')
if [ ! -z "${rtid}" ]
then
  echo "route table id: ${rtid}"
  aws --profile lfproduct-dev ec2 delete-route-table --route-table-id "${rtid}"
  res=$?
  if [ "${res}" = "0" ]
  then
    rm -f "route-table.json.secret"
  else
    echo "delete result: ${res}"
  fi
else
  echo "$0: no route-table.json.secret file"
fi
