#!/bin/bash
. ./env.sh
if [ ! -f "listener.json.${STAGE}.secret" ]
then
  alb=$(cat alb.json.${STAGE}.secret | jq -r '.LoadBalancers[].LoadBalancerArn')
  if [ -z "${alb}" ]
  then
    echo "$0: alb not found"
    exit 1
  fi
  echo "ALB: ${alb}"
  tg=$(cat target-group.json.${STAGE}.secret | jq -r '.TargetGroups[].TargetGroupArn')
  if [ -z "${tg}" ]
  then
    echo "$0: target group not found"
    exit 3
  fi
  echo "target group: ${tg}"
  aws --profile lfproduct-${STAGE} elbv2 create-listener --load-balancer-arn "${alb}" --protocol HTTP --port 80 --default-actions "Type=forward,TargetGroupArn=${tg}" > listener.json.${STAGE}.secret
  res=$?
  if [ ! "${res}" = "0" ]
  then
    echo "$0: create listener failed"
    rm -f "listener.json.${STAGE}.secret"
    exit 2
  fi
  lid=$(cat listener.json.${STAGE}.secret | jq -r '.Listeners[].ListenerArn')
  echo "listener: ${lid}"
else
  echo "$0: listener already created:"
  cat listener.json.${STAGE}.secret
fi
