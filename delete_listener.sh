#!/bin/bash
lid=$(cat listener.json.secret | jq -r '.Listeners[].ListenerArn')
if [ ! -z "${lid}" ]
then
  echo "listener arn: ${lid}"
  aws --profile lfproduct-dev elbv2 delete-listener --listener-arn "${lid}"
  res=$?
  if [ "${res}" = "0" ]
  then
    rm -f "listener.json.secret"
  else
    echo "delete result: ${res}"
  fi
else
  echo "$0: no listener.json.secret file"
fi
