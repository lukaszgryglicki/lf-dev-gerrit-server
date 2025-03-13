#!/bin/bash
for v in cache db etc git index lib plugins
do
  ./create_volume.sh "${v}"
done
