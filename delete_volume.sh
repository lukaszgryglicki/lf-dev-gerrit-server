#!/bin/bash
# volumes needed: cache db etc git index lib plugins
if [ -z "$1" ]
then
  echo "$0: you need to specify which volume to delete: cache db etc git index lib plugins"
  exit 1
fi
fsid=$(cat "volume-${1}.json.secret" | jq -r '.FileSystemId')
if [ -z "${fsid}" ]
then
  echo "$0: cannot find volume-${1}.json.secret file"
  exit 2
fi
echo "file system ID: ${fsid}, mount targets:"
aws  --profile lfproduct-dev efs describe-mount-targets --file-system-id "${fsid}"
# aws  --profile lfproduct-dev efs delete-mount-target --mount-target-id <MOUNT_TARGET_ID>
aws --profile lfproduct-dev efs delete-file-system --file-system-id "${fsid}"
res=$?
if [ "${res}" = "0" ]
then
  rm -f "volume-${1}.json.secret"
else
  echo "delete result: ${res}"
fi
