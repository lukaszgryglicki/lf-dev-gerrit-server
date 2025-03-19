#!/bin/bash
aws --profile lfproduct-dev ecs update-service --cluster dev_gerrit_cluster --service dev_gerrit_service --force-new-deployment
