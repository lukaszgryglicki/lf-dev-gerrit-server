#!/bin/bash
. ./env.sh
for v in cache db etc git index lib plugins
do
  echo "volume: ${v}"
  ./create_mount_target.sh "${v}"
done
