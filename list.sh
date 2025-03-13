#!/bin/bash
export VERBOSE=1
./list_azs.sh
./list_clusters.sh
for v in cache db etc git index lib plugins
do
  ./list_mount_targets.sh "${v}"
done
./list_task_definitions.sh
./list_services.sh
