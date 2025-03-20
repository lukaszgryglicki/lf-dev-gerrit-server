#!/bin/bash
. ./env.sh
for v in cache db etc git index lib plugins
do
  echo "volume: ${v}"
  ./create_volume.sh "${v}"
done
