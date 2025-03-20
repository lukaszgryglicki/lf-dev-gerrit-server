#!/bin/bash
. ./env.sh
if [ -z "$1" ]
then
  echo "$0: you need to specify which volume to delete as a 1st argument"
  exit 1
fi
fsid=$(cat "volume-${1}.json.${STAGE}.secret" | jq -r '.FileSystemId')
echo "file system id: ${fsid}"
if [ -z "${fsid}" ]
then
  echo "$0: cannot find volume-${1}.json.${STAGE}.secret file"
  exit 2
fi
aws --profile lfproduct-${STAGE} efs delete-file-system --file-system-id "${fsid}"
res=$?
if [ "${res}" = "0" ]
then
  rm -f "volume-${1}.json.${STAGE}.secret"
else
  echo "delete result: ${res}"
fi
