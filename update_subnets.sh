#!/bin/bash
. ./env.sh
for z in a b c d e f
do
  subnetid=$(cat "subnet-1${z}.json.${STAGE}.secret" | jq -r '.Subnet.SubnetId')
  echo "Subnet us-east-1${z} id: ${subnetid}"
  if [ ! -z "${subnetid}" ]
  then
    aws --profile lfproduct-${STAGE} ec2 modify-subnet-attribute --subnet-id "${subnetid}" --map-public-ip-on-launch
    res=$?
    if [ ! "${res}" = "0" ]
    then
      echo "$0: modify subnet attribute failed"
    else
      aws --profile lfproduct-${STAGE} ec2 describe-route-tables --filters "Name=association.subnet-id,Values=${subnetid}" --query "RouteTables[*].Routes"
    fi
  else
    echo "$0: cannot find subnet for us-east-1${z}"
  fi
done
