#!/bin/bash
. ./env.sh
aws --profile lfproduct-${STAGE} ecs describe-services --cluster dev_gerrit_cluster --service dev_gerrit_service
