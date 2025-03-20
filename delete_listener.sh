#!/bin/bash
. ./env.sh
lid=$(cat listener.json.${STAGE}.secret | jq -r '.Listeners[].ListenerArn')
if [ ! -z "${lid}" ]
then
  echo "listener arn: ${lid}"
  aws --profile lfproduct-${STAGE} elbv2 delete-listener --listener-arn "${lid}"
  res=$?
  if [ "${res}" = "0" ]
  then
    rm -f "listener.json.${STAGE}.secret"
  else
    echo "delete result: ${res}"
  fi
else
  echo "$0: no listener.json.${STAGE}.secret file"
fi
