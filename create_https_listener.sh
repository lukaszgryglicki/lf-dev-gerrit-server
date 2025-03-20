#!/bin/bash
. ./env.sh
if [ ! -f "https-listener.json.${STAGE}.secret" ]
then
  alb=$(cat alb.json.${STAGE}.secret | jq -r '.LoadBalancers[].LoadBalancerArn')
  if [ -z "${alb}" ]
  then
    echo "$0: alb not found"
    exit 1
  fi
  echo "ALB: ${alb}"
  cert=$(cat cert.json.${STAGE}.secret | jq -r '.CertificateArn')
  if [ -z "${cert}" ]
  then
    echo "$0: cert not found"
    exit 2
  fi
  echo "cert: ${cert}"
  tg=$(cat target-group.json.${STAGE}.secret | jq -r '.TargetGroups[].TargetGroupArn')
  if [ -z "${tg}" ]
  then
    echo "$0: target group not found"
    exit 3
  fi
  echo "target group: ${tg}"
  aws --profile lfproduct-${STAGE} elbv2 create-listener --load-balancer-arn "${alb}" --protocol HTTPS --port 443 --certificates "CertificateArn=${cert}" --default-actions "Type=forward,TargetGroupArn=${tg}" > https-listener.json.${STAGE}.secret
  res=$?
  if [ ! "${res}" = "0" ]
  then
    echo "$0: create https listener failed"
    rm -f "https-listener.json.${STAGE}.secret"
    exit 2
  fi
  lid=$(cat https-listener.json.${STAGE}.secret | jq -r '.Listeners[].ListenerArn')
  echo "listener: ${lid}"
else
  echo "$0: https listener already created:"
  cat https-listener.json.${STAGE}.secret
fi
