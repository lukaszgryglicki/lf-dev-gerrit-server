#!/bin/bash
. ./env.sh
aws --profile lfproduct-${STAGE} ec2 describe-availability-zones
