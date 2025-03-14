#!/bin/bash
# SSH=1 (to run OpenSSH server image for debugging purposes)
# {{url}} -> https://mockapi.gerrit.dev.itx.linuxfoundation.org
# {{fs-xyz}} -> fs-ids
# {[aws-acc-id}} -> aws-account-id.secret
# {{username}} -> username.secret
# {{password}} -> password.secret
if [ -f "task.json.secret" ]
then
  echo "$0: task definition already exists"
  cat task.json.secret
  exit 1
fi
url='https://lf.gerrit.dev.itx.linuxfoundation.org'
awsaccid=$(cat ./aws-account-id.secret)
username=$(cat ./username.secret)
password=$(cat ./password.secret)
# TODO: final image must be from both-template.json
if [ ! -z "$SSH" ]
then
  cp ./ssh-template.json ./task.json || exit 1
else
  cp ./gerrit-template.json ./task.json || exit 2
fi
sed -i "s|{{url}}|${url}|g" ./task.json
sed -i "s|{{aws-acc-id}}|${awsaccid}|g" ./task.json
sed -i "s|{{username}}|${username}|g" ./task.json
sed -i "s|{{password}}|${password}|g" ./task.json
for v in cache db etc git index lib plugins
do
  echo "volume: ${v}"
  fsid=$(cat "volume-${v}.json.secret" | jq -r '.FileSystemId')
  if [ -z "${fsid}" ]
  then
    echo "$0: file system id cannot be found for volume $v"
    exit 2
  fi
  sed -i "s|{{fs-${v}}}|${fsid}|g" ./task.json
done
aws --profile lfproduct-dev ecs register-task-definition --cli-input-json file://task.json > task.json.secret
res=$?
if [ ! "${res}" = "0" ]
then
  echo "$0: register task definition failed"
  exit 3
fi
taskarn=$(cat task.json.secret | jq -r '.taskDefinition.taskDefinitionArn')
echo "task arn: ${taskarn}"
