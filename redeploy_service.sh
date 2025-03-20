#!/bin/bash
. ./env.sh
aws --profile lfproduct-${STAGE} ecs update-service --cluster dev_gerrit_cluster --service dev_gerrit_service --force-new-deployment --deployment-configuration minimumHealthyPercent=0,maximumPercent=100
