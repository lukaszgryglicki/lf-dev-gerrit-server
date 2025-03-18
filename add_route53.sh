#!/bin/bash
# {{hosted-zone-id}} -> ./get_hosted_zone_id.sh
# {{alb-dns-name}} -> alb.json.secret | jq -r '.LoadBalancers[].DNSName'
if [ -f "route53.json.secret" ]
then
  echo "$0: route53 definition already exists"
  cat route53.json.secret
  exit 1
fi
rhzid="$(./get_hosted_zone_id.sh)"
if [ -z "${rhzid}" ]
then
  echo "$0: cannot get route 53 hosted zone id"
  exit 1
fi
echo "route 53 hosted zone id: ${rhzid}"
ahzid="$(aws --profile lfproduct-dev elbv2 describe-load-balancers --names dev-gerrit-alb | jq -r '.LoadBalancers[].CanonicalHostedZoneId')"
if [ -z "${ahzid}" ]
then
  echo "$0: cannot get alb hosted zone id"
  exit 1
fi
echo "alb hosted zone id: ${ahzid}"
albdns=$(cat alb.json.secret | jq -r '.LoadBalancers[].DNSName')
if [ -z "${albdns}" ]
then
  echo "$0: cannot get ALB DNS"
  exit 2
fi
echo "alb dns: ${albdns}"
cp ./dns-template.json ./dns.json || exit 3
sed -i "s|{{hosted-zone-id}}|${ahzid}|g" ./dns.json
sed -i "s|{{alb-dns-name}}|${albdns}|g" ./dns.json
echo aws --profile lfproduct-dev route53 change-resource-record-sets --hosted-zone-id "${rhzid}" --change-batch file://dns.json
aws --profile lfproduct-dev route53 change-resource-record-sets --hosted-zone-id "${rhzid}" --change-batch file://dns.json > dns.json.secret
