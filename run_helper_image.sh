#!/bin/bash
docker run -it "lukaszgryglicki/gerrit-root-bash" || echo "$0: you must build the image first: ./build_helper_image.sh"
