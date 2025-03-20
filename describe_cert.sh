#!/bin/bash
. ./env.sh
if [ -f "cert.json.${STAGE}.secret" ]
then
  cert=$(cat cert.json.${STAGE}.secret | jq -r '.CertificateArn')
  aws --profile lfproduct-${STAGE} acm describe-certificate --certificate-arn "${cert}"
  res=$?
  if [ ! "${res}" = "0" ]
  then
    echo "$0: describe cert failed"
    rm -f "describe-cert.json.${STAGE}.secret"
    exit 1
  fi
else
  echo "$0: cannot find cert"
fi
