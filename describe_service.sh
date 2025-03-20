#!/bin/bash
. ./env.sh
aws --profile lfproduct-${STAGE} ecs describe-services --cluster ${STAGE}_gerrit_cluster --service ${STAGE}_gerrit_service
