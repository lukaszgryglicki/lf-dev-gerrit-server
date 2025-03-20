#!/bin/bash
. ./env.sh
if [ -z "$1" ]
then
  echo "$0: you need to specify which volume mount target should be created as a 1st argument"
  exit 1
fi

for z in a b c d e f
do
  if [ ! -f "subnet-1${z}.json.${STAGE}.secret" ]
  then
    echo "subnet configuration for us-east-1${z} not found, skipping"
    continue
  fi
  subnetid=$(cat "subnet-1${z}.json.${STAGE}.secret" | jq -r '.Subnet.SubnetId')
  if [ -z "${subnetid}" ]
  then
    echo "subnet ID for us-east-1${z} not found, skipping"
    continue
  fi
  echo "subnet us-east-1${z} id: ${subnetid}"
  mtid=$(cat "mount-${1}-1${z}.json.${STAGE}.secret" | jq -r '.MountTargetId')
  if [ ! -z "${mtid}" ]
  then
    echo "mount target id: ${mtid}"
    aws --profile lfproduct-${STAGE} efs delete-mount-target --mount-target-id "${mtid}"
    res=$?
    if [ "${res}" = "0" ]
    then
      rm -f "mount-${1}-1${z}.json.${STAGE}.secret"
    else
      echo "delete result: ${res}"
    fi
  else
    echo "$0: no mount-${1}-1${z}.json.${STAGE}.secret file"
  fi
done
