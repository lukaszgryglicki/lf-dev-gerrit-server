#!/bin/bash
. ./env.sh
# {{hosted-zone-id}} -> ./get_hosted_zone_id.sh
# {{alb-dns-name}} -> alb.json.${STAGE}.secret | jq -r '.LoadBalancers[].DNSName'
# {{nlb-dns-name}} -> nlb.json.${STAGE}.secret | jq -r '.LoadBalancers[].DNSName'
if [ -f "route53.json.${STAGE}.secret" ]
then
  echo "$0: route53 definition already exists"
  cat route53.json.${STAGE}.secret
  exit 1
fi
rhzid="$(./get_hosted_zone_id.sh)"
if [ -z "${rhzid}" ]
then
  echo "$0: cannot get route 53 hosted zone id"
  exit 2
fi
echo "route 53 hosted zone id: ${rhzid}"
ahzid="$(aws --profile lfproduct-${STAGE} elbv2 describe-load-balancers --names ${STAGE}-gerrit-alb | jq -r '.LoadBalancers[].CanonicalHostedZoneId')"
if [ -z "${ahzid}" ]
then
  echo "$0: cannot get alb hosted zone id"
  exit 3
fi
echo "alb hosted zone id: ${ahzid}"
albdns=$(cat alb.json.${STAGE}.secret | jq -r '.LoadBalancers[].DNSName')
if [ -z "${albdns}" ]
then
  echo "$0: cannot get ALB DNS"
  exit 4
fi
echo "alb dns: ${albdns}"
nlbdns=$(cat nlb.json.${STAGE}.secret | jq -r '.LoadBalancers[].DNSName')
if [ -z "${nlbdns}" ]
then
  echo "$0: cannot get NLB DNS"
  exit 5
fi
echo "nlb dns: ${nlbdns}"
cp ./dns-template.${STAGE}.json ./dns.${STAGE}.json || exit 6
sed -i "s|{{hosted-zone-id}}|${ahzid}|g" ./dns.${STAGE}.json
sed -i "s|{{alb-dns-name}}|${albdns}|g" ./dns.${STAGE}.json
echo aws --profile lfproduct-${STAGE} route53 change-resource-record-sets --hosted-zone-id "${rhzid}" --change-batch "file://dns.${STAGE}.json"
aws --profile lfproduct-${STAGE} route53 change-resource-record-sets --hosted-zone-id "${rhzid}" --change-batch "file://dns.${STAGE}.json" > dns.json.${STAGE}.secret
cp ./ssh-dns-template.${STAGE}.json ./ssh-dns.${STAGE}.json || exit 7
sed -i "s|{{nlb-dns-name}}|${nlbdns}|g" ./ssh-dns.${STAGE}.json
echo aws --profile lfproduct-${STAGE} route53 change-resource-record-sets --hosted-zone-id "${rhzid}" --change-batch "file://ssh-dns.${STAGE}.json"
aws --profile lfproduct-${STAGE} route53 change-resource-record-sets --hosted-zone-id "${rhzid}" --change-batch "file://ssh-dns.${STAGE}.json" > ssh-dns.json.${STAGE}.secret
