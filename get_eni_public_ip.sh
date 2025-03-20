#!/bin/bash
. ./env.sh
# GETENI=1
eni="${1}"
if [ -z "${eni}" ]
then
  if [ ! -z "$GETENI" ]
  then
     data=$(./list_cluster_tasks.sh | grep -i eni)
     eni=$(echo "{${data}}" | jq -r '.value')
  else
    echo "$0: you need to specify ENI-ID as a 1st argument - you can get one via './list_cluster_tasks.sh | grep -i eni' or use GETENI=1"
    exit 1
  fi
fi
aws --profile lfproduct-${STAGE} ec2 describe-network-interfaces --network-interface-ids "${eni}" --query "NetworkInterfaces[0].Association.PublicIp" --output text
