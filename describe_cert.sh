#!/bin/bash
if [ -f "cert.json.secret" ]
then
  cert=$(cat cert.json.secret | jq -r '.CertificateArn')
  aws --profile lfproduct-dev acm describe-certificate --certificate-arn "${cert}"
  res=$?
  if [ ! "${res}" = "0" ]
  then
    echo "$0: describe cert failed"
    rm -f "describe-cert.json.secret"
    exit 1
  fi
else
  echo "$0: cannot find cert"
fi
