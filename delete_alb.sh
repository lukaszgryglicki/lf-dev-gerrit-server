#!/bin/bash
. ./env.sh
alb=$(cat alb.json.${STAGE}.secret | jq -r '.LoadBalancers[].LoadBalancerArn')
if [ ! -z "${alb}" ]
then
  echo "alb arn: ${alb}"
  aws --profile lfproduct-${STAGE} elbv2 delete-load-balancer --load-balancer-arn "${alb}"
  res=$?
  if [ "${res}" = "0" ]
  then
    rm -f "alb.json.${STAGE}.secret"
  else
    echo "delete result: ${res}"
  fi
else
  echo "$0: no alb.json.${STAGE}.secret file"
fi
