#!/bin/bash
. ./env.sh
image_id="$(docker ps --filter ancestor="lukaszgryglicki/gerrit-root-bash" --format "{{.ID}}" | head -n 1)"
if [ -z "${image_id}" ]
then
  echo "$0: you must run the image first: ./run_helper_image.sh"
  exit 1
fi
docker cp "${image_id}:/gerrit.tar" ./gerrit.tar
