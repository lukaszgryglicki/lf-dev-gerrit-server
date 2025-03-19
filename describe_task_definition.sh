#!/bin/bash
aws --profile lfproduct-dev ecs describe-task-definition --task-definition dev-gerrit-service
