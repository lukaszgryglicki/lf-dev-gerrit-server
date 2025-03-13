#!/bin/bash
if [ -z "$1" ]
then
  echo "$0: you need to specify which volume mount target should be created as a 1st argument"
  exit 1
fi
sgid=$(cat security-group.json.secret | jq -r '.GroupId')
if [ -z "${sgid}" ]
then
  echo "$0: no security group id found"
  exit 2
fi
echo "security group ID: ${sgid}"
fsid=$(cat "volume-${1}.json.secret" | jq -r '.FileSystemId')
if [ -z "${fsid}" ]
then
  echo "$0: cannot find volume-${1}.json.secret file"
  exit 3
fi
echo "file system id: ${fsid}"

for z in a b c d e f
do
  if [ ! -f "subnet-1${z}.json.secret" ]
  then
    echo "subnet configuration for us-east-1${z} not found, skipping"
    continue
  fi
  subnetid=$(cat "subnet-1${z}.json.secret" | jq -r '.Subnet.SubnetId')
  if [ -z "${subnetid}" ]
  then
    echo "subnet ID for us-east-1${z} not found, skipping"
    continue
  fi
  echo "subnet us-east-1${z} id: ${subnetid}"
  if [ ! -f "mount-${1}-1${z}.json.secret" ]
  then
    aws --profile lfproduct-dev efs create-mount-target --file-system-id "${fsid}" --subnet-id "${subnetid}" --security-groups "${sgid}" > "mount-${1}-1${z}.json.secret"
    res=$?
    if [ ! "${res}" = "0" ]
    then
      echo "$0: create mount target failed"
      rm -f "mount-${1}-1${z}.json.secret"
      continue
    fi
    mtid=$(cat "mount-${1}-1${z}.json.secret" | jq -r '.MountTargetId')
    echo "mount target ID: ${mtid}"
  else
    echo "mount $1 for us-east-1${z} already created:"
    cat "mount-${1}-1${z}.json.secret"
  fi
done
