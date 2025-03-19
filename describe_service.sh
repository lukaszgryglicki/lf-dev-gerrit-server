#!/bin/bash
aws --profile lfproduct-dev ecs describe-services --cluster dev_gerrit_cluster --service dev_gerrit_service
