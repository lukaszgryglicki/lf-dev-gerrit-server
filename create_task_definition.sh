#!/bin/bash
. ./env.sh
# SSH=1 (to run OpenSSH server image for debugging purposes)
# {{url}} -> "https://$(cat ./domain.${STAGE}.secret)/"
# {{fs-xyz}} -> fs-ids
# {[aws-acc-id}} -> aws-account-id.${STAGE}.secret
# {{username}} -> username.${STAGE}.secret
# {{password}} -> password.${STAGE}.secret
if [ -f "task.json.${STAGE}.secret" ]
then
  echo "$0: task definition already exists"
  cat task.json.${STAGE}.secret
  exit 1
fi
dom="$(cat ./domain.${STAGE}.secret)"
if [ -z "${dom}" ]
then
  echo "$0: cannot fine domain name"
  exit 2
fi
url="https://${dom}/"
echo "domain: ${dom}, url: ${url}"
awsaccid=$(cat ./aws-account-id.${STAGE}.secret)
username=$(cat ./username.${STAGE}.secret)
password=$(cat ./password.${STAGE}.secret)
if [ ! -z "$SSH" ]
then
  cp ./ssh-template.${STAGE}.json ./task.${STAGE}.json || exit 3
else
  # cp ./gerrit-template.${STAGE}.json ./task.${STAGE}.json || exit 3
  cp ./both-template.${STAGE}.json ./task.${STAGE}.json || exit 4
fi
sed -i "s|{{url}}|${url}|g" ./task.${STAGE}.json
sed -i "s|{{aws-acc-id}}|${awsaccid}|g" ./task.${STAGE}.json
sed -i "s|{{username}}|${username}|g" ./task.${STAGE}.json
sed -i "s|{{password}}|${password}|g" ./task.${STAGE}.json
for v in cache db etc git index lib plugins
do
  echo "volume: ${v}"
  fsid=$(cat "volume-${v}.json.${STAGE}.secret" | jq -r '.FileSystemId')
  if [ -z "${fsid}" ]
  then
    echo "$0: file system id cannot be found for volume $v"
    exit 5
  fi
  sed -i "s|{{fs-${v}}}|${fsid}|g" ./task.${STAGE}.json
done
aws --profile lfproduct-${STAGE} ecs register-task-definition --cli-input-json "file://task.${STAGE}.json" > task.json.${STAGE}.secret
res=$?
if [ ! "${res}" = "0" ]
then
  echo "$0: register task definition failed"
  exit 6
fi
taskarn=$(cat task.json.${STAGE}.secret | jq -r '.taskDefinition.taskDefinitionArn')
echo "task arn: ${taskarn}"
