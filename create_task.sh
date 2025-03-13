#!/bin/bash
# {{url}} -> https://mockapi.gerrit.dev.itx.linuxfoundation.org
# {{fs-xyz}} -> fs-ids
# {[aws-acc-id}} -> aws-account-id.secret
url='https://lf.gerrit.dev.itx.linuxfoundation.org'
awsaccid=$(cat ./aws-account-id.secret)
cp ./task-template.json ./task.json || exit 1
sed -i "s|{{url}}|${url}|g" ./task.json
sed -i "s|{{aws-acc-id}}|${awsaccid}|g" ./task.json
for v in cache db etc git index lib plugins
do
  fsid=$(cat "volume-${v}.json.secret" | jq -r '.FileSystemId')
  if [ -z "${fsid}" ]
  then
    echo "$0: file system id cannot be found for volume $v"
    exit 2
  fi
  sed -i "s|{{fs-${v}}}|${fsid}|g" ./task.json
done
aws --profile lfproduct-dev ecs register-task-definition --cli-input-json file://task.json > task.json.secret
taskarn=$(cat task.json.secret | jq -r '.taskDefinition.taskDefinitionArn')
echo "task arn: ${taskarn}"
