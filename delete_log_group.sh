#!/bin/bash
. ./env.sh
aws --profile lfproduct-${STAGE} logs delete-log-group --log-group-name lf_${STAGE}_gerrit
res=$?
if [ ! "${res}" = "0" ]
then
  echo "delete result: ${res}"
fi
