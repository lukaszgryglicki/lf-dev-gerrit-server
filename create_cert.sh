#!/bin/bash
if [ ! -f "cert.json.secret" ]
then
  aws --profile lfproduct-dev acm request-certificate --domain-name lf.gerrit.dev.itx.linuxfoundation.org --subject-alternative-names "alt.lf.gerrit.dev.itx.linuxfoundation.org" --validation-method DNS --region us-east-1 > cert.json.secret
  res=$?
  if [ ! "${res}" = "0" ]
  then
    echo "$0: create cert failed"
    rm -f "cert.json.secret"
    exit 2
  fi
  cert=$(cat cert.json.secret | jq -r '.CertificateArn')
  echo "cert arn: ${cert}"
else
  echo "$0: cert already created:"
  cat cert.json.secret
fi
