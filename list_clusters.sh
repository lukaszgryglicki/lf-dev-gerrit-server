#!/bin/bash
. ./env.sh
aws --profile lfproduct-${STAGE} ecs list-clusters
