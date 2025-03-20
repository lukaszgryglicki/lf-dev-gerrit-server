#!/bin/bash
. ./env.sh
if [ ! -f "route.json.${STAGE}.secret" ]
then
  rtid=$(cat route-table.json.${STAGE}.secret | jq -r '.RouteTable.RouteTableId')
  echo "route table id: ${rtid}"
  if [ -z "${rtid}" ]
  then
    echo "$0: no route table found"
    exit 1
  fi
  igwid=$(cat inet-gw.json.${STAGE}.secret | jq -r '.InternetGateway.InternetGatewayId')
  echo "inet gw id: ${igwid}"
  if [ -z "${igwid}" ]
  then
    echo "$0: no inet gw found"
    exit 2
  fi
  aws --profile lfproduct-${STAGE} ec2 create-route --route-table-id "${rtid}" --destination-cidr-block 0.0.0.0/0 --gateway-id "${igwid}" > route.json.${STAGE}.secret
  res=$?
  if [ ! "${res}" = "0" ]
  then
    echo "$0: create route failed"
    rm -f "route.json.${STAGE}.secret"
    exit 3
  fi
else
  echo "$0: route already created:"
  cat route.json.${STAGE}.secret
fi
