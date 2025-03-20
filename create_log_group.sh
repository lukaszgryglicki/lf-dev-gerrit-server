#!/bin/bash
. ./env.sh
aws --profile lfproduct-${STAGE} logs create-log-group --log-group-name lf_dev_gerrit
res=$?
if [ ! "${res}" = "0" ]
then
  echo "$0: create log group failed"
fi
