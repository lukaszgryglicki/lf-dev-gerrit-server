#!/bin/bash
# {{hosted-zone-id}} -> ./get_hosted_zone_id.sh
# {{alb-dns-name}} -> alb.json.secret | jq -r '.LoadBalancers[].DNSName'
if [ -f "route53.json.secret" ]
then
  echo "$0: route53 definition already exists"
  cat route53.json.secret
  exit 1
fi
hzid="$(./get_hosted_zone_id.sh)"
if [ -z "${hzid}" ]
then
  echo "$0: cannot get hosted zoe id"
  exit 1
fi
echo "hosted zone id: ${hzid}"
albdns=$(cat alb.json.secret | jq -r '.LoadBalancers[].DNSName')
if [ -z "${albdns}" ]
then
  echo "$0: cannot get ALB DNS"
  exit 2
fi
echo "alb dns: ${albdns}"
cp ./dns-template.json ./dns.json || exit 3
sed -i "s|{{hosted-zone-id}}|${hzid}|g" ./dns.json
sed -i "s|{{alb-dns-name}}|${albdns}|g" ./dns.json
echo aws --profile lfproduct-dev route53 change-resource-record-sets --hosted-zone-id "${hzid}" --change-batch file://dns.json
aws --profile lfproduct-dev route53 change-resource-record-sets --hosted-zone-id "${hzid}" --change-batch file://dns.json > dns.json.secret
