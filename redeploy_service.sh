#!/bin/bash
. ./env.sh
aws --profile lfproduct-${STAGE} ecs update-service --cluster ${STAGE}_gerrit_cluster --service ${STAGE}_gerrit_service --force-new-deployment --deployment-configuration minimumHealthyPercent=0,maximumPercent=100
