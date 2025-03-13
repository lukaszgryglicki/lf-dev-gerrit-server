#!/bin/bash
if [ ! -f "route.json.secret" ]
then
  rtid=$(cat route-table.json.secret | jq -r '.RouteTable.RouteTableId')
  echo "route table id: ${rtid}"
  if [ -z "${rtid}" ]
  then
    echo "$0: no route table found"
    exit 1
  fi
  igwid=$(cat inet-gw.json.secret | jq -r '.InternetGateway.InternetGatewayId')
  echo "inet gw id: ${igwid}"
  if [ -z "${igwid}" ]
  then
    echo "$0: no inet gw found"
    exit 2
  fi
  aws --profile lfproduct-dev ec2 create-route --route-table-id "${rtid}" --destination-cidr-block 0.0.0.0/0 --gateway-id "${igwid}" > route.json.secret
  res=$?
  if [ ! "${res}" = "0" ]
  then
    echo "$0: create route failed"
    rm -f "route.json.secret"
    exit 3
  fi
else
  echo "$0: route already created:"
  cat route.json.secret
fi
