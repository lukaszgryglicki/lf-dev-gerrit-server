#!/bin/bash
for v in cache db etc git index lib plugins
do
  echo "volume: ${v}"
  ./delete_volume.sh "${v}"
done
