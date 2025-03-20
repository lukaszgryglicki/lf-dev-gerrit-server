#!/bin/bash
. ./env.sh
nlb=$(cat nlb.json.${STAGE}.secret | jq -r '.LoadBalancers[].LoadBalancerArn')
if [ ! -z "${nlb}" ]
then
  echo "nlb arn: ${nlb}"
  aws --profile lfproduct-${STAGE} elbv2 delete-load-balancer --load-balancer-arn "${nlb}"
  res=$?
  if [ "${res}" = "0" ]
  then
    rm -f "nlb.json.${STAGE}.secret"
  else
    echo "delete result: ${res}"
  fi
else
  echo "$0: no nlb.json.${STAGE}.secret file"
fi
