#!/bin/bash
. ./env.sh
# GETIP=1
ip="${1}"
if [ -z "${ip}" ]
then
  if [ ! -z "$GETIP" ]
  then
    ip=$(GETENI=1 ./get_eni_public_ip.sh)
  else
    echo "$0: you need to specify task IP, or use GETIP=1"
    exit 1
  fi
fi
usr=$(cat ./username.${STAGE}.secret)
pwd=$(cat ./password.${STAGE}.secret)
echo "sftp -o 'Port=2222' ${usr}@${ip}"
echo "password is: ${pwd}"
sftp -o "Port=2222" "${usr}@${ip}"
