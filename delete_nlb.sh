#!/bin/bash
nlb=$(cat nlb.json.secret | jq -r '.LoadBalancers[].LoadBalancerArn')
if [ ! -z "${nlb}" ]
then
  echo "nlb arn: ${nlb}"
  aws --profile lfproduct-dev elbv2 delete-load-balancer --load-balancer-arn "${nlb}"
  res=$?
  if [ "${res}" = "0" ]
  then
    rm -f "nlb.json.secret"
  else
    echo "delete result: ${res}"
  fi
else
  echo "$0: no nlb.json.secret file"
fi
