#!/bin/bash
for v in cache db etc git index lib plugins
do
  echo "deleting $v"
  ./delete_mount_target.sh "${v}"
done
