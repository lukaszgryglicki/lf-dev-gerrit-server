#!/bin/bash
. ./env.sh
key_path=$(cat ./private-key-path.${STAGE}.secret)
domain="$(cat ./domain.${STAGE}.secret)"
ssh -o Port=29418 -i "${key_path}" "admin@ssh.${domain}" gerrit version
