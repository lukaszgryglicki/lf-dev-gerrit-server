#!/bin/bash
if [ -z "$VERBOSE" ]
then
  aws --profile lfproduct-dev ecs list-task-definitions --family-prefix dev-gerrit-service | jq -r '.taskDefinitionArns[]'
else
  aws --profile lfproduct-dev ecs list-task-definitions --family-prefix dev-gerrit-service | jq -r
fi
