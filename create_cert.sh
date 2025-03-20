#!/bin/bash
. ./env.sh
dom="$(cat domain.${STAGE}.secret)"
if [ -z "${dom}" ]
then
  echo "$0: cannot fine domain name"
  exit 1
fi
echo "domain: ${dom}"
if [ ! -f "cert.json.${STAGE}.secret" ]
then
  aws --profile lfproduct-${STAGE} acm request-certificate --domain-name "${dom}" --validation-method DNS > cert.json.${STAGE}.secret
  res=$?
  if [ ! "${res}" = "0" ]
  then
    echo "$0: create cert failed"
    rm -f "cert.json.${STAGE}.secret"
    exit 2
  fi
  cert=$(cat cert.json.${STAGE}.secret | jq -r '.CertificateArn')
  echo "cert arn: ${cert}"
else
  echo "$0: cert already created:"
  cat cert.json.${STAGE}.secret
fi
