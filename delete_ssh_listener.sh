#!/bin/bash
lid=$(cat ssh-listener.json.secret | jq -r '.Listeners[].ListenerArn')
if [ ! -z "${lid}" ]
then
  echo "ssh listener arn: ${lid}"
  aws --profile lfproduct-dev elbv2 delete-listener --listener-arn "${lid}"
  res=$?
  if [ "${res}" = "0" ]
  then
    rm -f "ssh-listener.json.secret"
  else
    echo "delete result: ${res}"
  fi
else
  echo "$0: no ssh-listener.json.secret file"
fi
