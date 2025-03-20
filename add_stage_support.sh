#!/bin/bash
if [ -z "${1}" ]
then
  echo "$0: please specify file as an argument"
  exit 1
fi
sed -i '/^#!\/bin\/bash/a . ./env.sh' "${1}"
sed -i 's/lfproduct-dev/lfproduct-${STAGE}/g' "${1}"
sed -i 's/-dev/-${STAGE}/g' "${1}"
sed -i 's/dev-/${STAGE}-/g' "${1}"
sed -i 's/\.secret/\.${STAGE}.secret/g' "${1}"
