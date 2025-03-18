#!/bin/bash
aws --profile lfproduct-dev route53 list-hosted-zones-by-name --dns-name 'dev.platform.linuxfoundation.org' | jq -r '.HostedZones[].Id'
