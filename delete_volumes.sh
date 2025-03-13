#!/bin/bash
for v in cache db etc git index lib plugins
do
  ./delete_volume.sh "${v}"
done
