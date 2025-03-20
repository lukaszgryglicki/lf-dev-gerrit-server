#!/bin/bash
. ./env.sh
if [ -z "$1" ]
then
  echo "$0: you need to specify which volume to create as a 1st argument"
  exit 1
fi
if [ ! -f "volume-${1}.json.${STAGE}.secret" ]
then
  aws --profile lfproduct-${STAGE} efs create-file-system --performance-mode generalPurpose --throughput-mode bursting --tags "Key=Name,Value=${STAGE}_gerrit_${1}" > "volume-${1}.json.${STAGE}.secret"
  res=$?
  if [ ! "${res}" = "0" ]
  then
    echo "$0: create file system failed"
    rm -f "volume-${1}.json.${STAGE}.secret"
    exit 2
  fi
  fsid=$(cat "volume-${1}.json.${STAGE}.secret" | jq -r '.FileSystemId')
  # fsid=$(aws --profile lfproduct-${STAGE} efs describe-file-systems --query "FileSystems[?Tags[?Key=='Name' && Value=='${STAGE}_gerrit_${1}']].FileSystemId" --output text)
  if [ -z "${fsid}" ]
  then
    echo "$0: cannot get file system id from volume-${1}.json.${STAGE}.secret file"
    exit 3
  fi
  echo "file system ID: ${fsid}"
else
  echo "$0: volume-${1} already created:"
  cat "volume-${1}.json.${STAGE}.secret"
fi
