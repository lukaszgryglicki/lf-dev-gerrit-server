#!/bin/bash
. ./env.sh
domain="$(cat ./domain.${STAGE}.secret)"
higher_domain="${domain#gerrit.}"
hzid="$(aws --profile lfproduct-${STAGE} route53 list-hosted-zones-by-name --dns-name "${higher_domain}" | jq -r '.HostedZones[].Id')"
hzid="${hzid#/hostedzone/}"
echo "${hzid}"
