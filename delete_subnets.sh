#!/bin/bash
for z in a b c d e f
do
  subnetid=$(cat "subnet-1${z}.json.secret" | jq -r '.Subnet.SubnetId')
  echo "Subnet us-east-1${z} id: ${subnetid}"
  if [ ! -z "${subnetid}" ]
  then
    aws --profile lfproduct-dev ec2 delete-subnet --subnet-id "${subnetid}"
    res=$?
    if [ "${res}" = "0" ]
    then
      rm -f "subnet-1${z}.json.secret"
    else
      echo "delete result: ${res}"
    fi
  fi
done
