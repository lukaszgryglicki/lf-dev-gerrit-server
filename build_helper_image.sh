#!/bin/bash
. ./env.sh
docker build -f ./Dockerfile.helper -t "lukaszgryglicki/gerrit-root-bash" .
