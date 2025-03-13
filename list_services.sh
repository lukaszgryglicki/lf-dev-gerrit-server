#!/bin/bash
aws --profile lfproduct-dev ecs list-services --cluster dev_gerrit_cluster | jq -r '.'
