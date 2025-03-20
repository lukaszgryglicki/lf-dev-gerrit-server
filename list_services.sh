#!/bin/bash
. ./env.sh
aws --profile lfproduct-${STAGE} ecs list-services --cluster ${STAGE}_gerrit_cluster | jq -r '.'
