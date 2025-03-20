#!/bin/bash
. ./env.sh
aws --profile lfproduct-${STAGE} ecs describe-task-definition --task-definition ${STAGE}-gerrit-service
