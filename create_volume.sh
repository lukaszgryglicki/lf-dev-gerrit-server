#!/bin/bash
# volumes needed: cache db etc git index lib plugins 
if [ -z "$1" ]
then
  echo "$0: you need to specify which volume to create: cache db etc git index lib plugins"
  exit 1
fi
aws --profile lfproduct-dev efs create-file-system --performance-mode generalPurpose --throughput-mode bursting --tags "Key=Name,Value=dev_gerrit_${1}" > "volume-${1}.json.secret"
fsid=$(cat "volume-${1}.json.secret" | jq -r '.FileSystemId')
# fsid=$(aws --profile lfproduct-dev efs describe-file-systems --query "FileSystems[?Tags[?Key=='Name' && Value=='dev_gerrit_${1}']].FileSystemId" --output text)
if [ -z "${fsid}" ]
then
  echo "$0: cannot get file system id from volume-${1}.json.secret file"
  exit 2
fi
echo "file system ID: ${fsid}"
vpcid=$(aws --profile lfproduct-dev ec2 describe-vpcs --query "Vpcs[0].VpcId" --output text)
echo "VPC ID: ${vpcid}"
subnetid=$(aws --profile lfproduct-dev ec2 describe-subnets --query "Subnets[0].SubnetId" --output text)
echo "subnet ID: ${subnetid}"
aws efs create-mount-target --file-system-id <EFS_ID> --subnet-id <SUBNET_ID> --security-groups <SECURITY_GROUP_ID>
