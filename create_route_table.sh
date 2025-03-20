#!/bin/bash
. ./env.sh
if [ ! -f "route-table.json.${STAGE}.secret" ]
then
  vpcid=$(cat vpc.json.${STAGE}.secret | jq -r '.Vpc.VpcId')
  echo "VPC id: ${vpcid}"
  if [ -z "${vpcid}" ]
  then
    echo "$0: no VPC found"
    exit 1
  fi
  aws --profile lfproduct-${STAGE} ec2 create-route-table --vpc-id "${vpcid}" > route-table.json.${STAGE}.secret
  res=$?
  if [ ! "${res}" = "0" ]
  then
    echo "$0: create route table failed"
    rm -f "route-table.json.${STAGE}.secret"
    exit 1
  fi
  rtid=$(cat route-table.json.${STAGE}.secret | jq -r '.RouteTable.RouteTableId')
  echo "route table id: ${rtid}"
else
  echo "$0: route table already created:"
  cat route-table.json.${STAGE}.secret
fi
