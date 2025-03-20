#!/bin/bash
. ./env.sh
aws --profile lfproduct-${STAGE} route53 list-hosted-zones
