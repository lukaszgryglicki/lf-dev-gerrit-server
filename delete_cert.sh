#!/bin/bash
cert=$(cat cert.json.secret | jq -r '.CertificateArn')
if [ ! -z "${cert}" ]
then
  echo "certificate arn: ${cert}"
  aws --profile lfproduct-dev acm delete-certificate --certificate-arn "${cert}"
  res=$?
  if [ "${res}" = "0" ]
  then
    rm -f "cert.json.secret"
  else
    echo "delete result: ${res}"
  fi
else
  echo "$0: no cert.json.secret file"
fi
