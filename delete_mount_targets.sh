#!/bin/bash
. ./env.sh
for v in cache db etc git index lib plugins
do
  echo "volume $v"
  ./delete_mount_target.sh "${v}"
done
