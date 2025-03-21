#!/bin/bash
. ./env.sh
if [ -f "cert.json.${STAGE}.secret" ]
then
  rhzid="$(./get_hosted_zone_id.sh)"
  if [ -z "${rhzid}" ]
  then
    echo "$0: cannot get route 53 hosted zone id"
    exit 1
  fi
  echo "route 53 hosted zone id: ${rhzid}"
  cert=$(cat cert.json.${STAGE}.secret | jq -r '.CertificateArn')
  aws --profile lfproduct-${STAGE} acm describe-certificate --certificate-arn "${cert}" > describe-cert.json.${STAGE}.secret
  res=$?
  if [ ! "${res}" = "0" ]
  then
    echo "$0: describe cert failed"
    rm -f "describe-cert.json.${STAGE}.secret"
    exit 2
  fi
  name=$(cat describe-cert.json.${STAGE}.secret | jq -r '.Certificate.DomainValidationOptions[].ResourceRecord.Name')
  value=$(cat describe-cert.json.${STAGE}.secret | jq -r '.Certificate.DomainValidationOptions[].ResourceRecord.Value')
  echo "cert arn: ${cert}"
  echo "name/value: ${name}/${value}"
  aws --profile lfproduct-${STAGE} route53 change-resource-record-sets --hosted-zone-id "${rhzid}" --change-batch "{\"Changes\": [{\"Action\": \"CREATE\",\"ResourceRecordSet\": {\"Name\": \"${name}\",\"Type\": \"CNAME\",\"TTL\": 300,\"ResourceRecords\": [{\"Value\": \"${value}\"}]}}]}" > validate-cert.json.${STAGE}.secret
  res=$?
  if [ ! "${res}" = "0" ]
  then
    echo "$0: validate cert failed"
    rm -f "validate-cert.json.${STAGE}.secret"
    exit 3
  fi
else
  echo "$0: cannot find cert"
fi
