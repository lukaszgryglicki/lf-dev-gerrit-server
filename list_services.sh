#!/bin/bash
. ./env.sh
aws --profile lfproduct-${STAGE} ecs list-services --cluster dev_gerrit_cluster | jq -r '.'
