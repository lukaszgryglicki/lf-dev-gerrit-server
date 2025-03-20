#!/bin/bash
. ./env.sh
aws --profile lfproduct-${STAGE} logs create-log-group --log-group-name lf_${STAGE}_gerrit
res=$?
if [ ! "${res}" = "0" ]
then
  echo "$0: create log group failed"
fi
