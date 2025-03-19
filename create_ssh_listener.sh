#!/bin/bash
if [ ! -f "ssh-listener.json.secret" ]
then
  nlb=$(cat nlb.json.secret | jq -r '.LoadBalancers[].LoadBalancerArn')
  if [ -z "${nlb}" ]
  then
    echo "$0: nlb not found"
    exit 1
  fi
  echo "NLB: ${nlb}"
  tg=$(cat target-group-ssh.json.secret | jq -r '.TargetGroups[].TargetGroupArn')
  if [ -z "${tg}" ]
  then
    echo "$0: target group not found"
    exit 3
  fi
  echo "ssh target group: ${tg}"
  aws --profile lfproduct-dev elbv2 create-listener --load-balancer-arn "${nlb}" --protocol TCP --port 29418 --default-actions "Type=forward,TargetGroupArn=${tg}" > ssh-listener.json.secret
  res=$?
  if [ ! "${res}" = "0" ]
  then
    echo "$0: create ssh listener failed"
    rm -f "ssh-listener.json.secret"
    exit 2
  fi
  lid=$(cat ssh-listener.json.secret | jq -r '.Listeners[].ListenerArn')
  echo "ssh listener: ${lid}"
else
  echo "$0: ssh listener already created:"
  cat ssh-listener.json.secret
fi
