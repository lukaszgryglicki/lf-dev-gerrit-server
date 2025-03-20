#!/bin/bash
. ./env.sh
cert=$(cat cert.json.${STAGE}.secret | jq -r '.CertificateArn')
if [ ! -z "${cert}" ]
then
  echo "certificate arn: ${cert}"
  aws --profile lfproduct-${STAGE} acm delete-certificate --certificate-arn "${cert}"
  res=$?
  if [ "${res}" = "0" ]
  then
    rm -f "cert.json.${STAGE}.secret"
  else
    echo "delete result: ${res}"
  fi
else
  echo "$0: no cert.json.${STAGE}.secret file"
fi
