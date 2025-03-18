#!/bin/bash
alb=$(cat alb.json.secret | jq -r '.LoadBalancers[].LoadBalancerArn')
if [ ! -z "${alb}" ]
then
  echo "alb arn: ${alb}"
  aws --profile lfproduct-dev elbv2 delete-load-balancer --load-balancer-arn "${alb}"
  res=$?
  if [ "${res}" = "0" ]
  then
    rm -f "alb.json.secret"
  else
    echo "delete result: ${res}"
  fi
else
  echo "$0: no alb.json.secret file"
fi
