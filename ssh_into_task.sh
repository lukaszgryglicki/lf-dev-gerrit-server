#!/bin/bash
# GETIP=1
ip="${1}"
if [ -z "${ip}" ]
then
  if [ ! -z "$GETIP" ]
  then
    ip=$(GETENI=1 ./get_eni_public_ip.sh)
  else
    echo "$0: you need to specify task IP"
    exit 1
  fi
fi
usr=$(cat ./username.secret)
pwd=$(cat ./password.secret)
echo "ssh -p 2222 ${usr}@${ip}"
echo "sftp -o 'Port=2222' ${usr}@${ip}"
echo "password is: ${pwd}"
ssh -p 2222 "${usr}@${ip}"
