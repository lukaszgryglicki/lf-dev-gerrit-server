#!/bin/bash
. ./env.sh
if [ -z "$1" ]
then
  echo "$0: you need to specify which volume mount targets should be listed"
  exit 1
fi
fsid=$(cat "volume-${1}.json.${STAGE}.secret" | jq -r '.FileSystemId')
echo "file system id: ${fsid}"
if [ -z "${fsid}" ]
then
  echo "$0: cannot find volume-${1}.json.${STAGE}.secret file"
  exit 2
fi
if [ -z "$VERBOSE" ]
then
  aws  --profile lfproduct-${STAGE} efs describe-mount-targets --file-system-id "${fsid}" | jq -r '.MountTargets[].MountTargetId'
else
  aws  --profile lfproduct-${STAGE} efs describe-mount-targets --file-system-id "${fsid}" | jq -r '.'
fi
