#!/bin/bash
aws --profile lfproduct-dev ecs list-task-definitions --family-prefix dev-gerrit-service | jq -r '.taskDefinitionArns[]'
