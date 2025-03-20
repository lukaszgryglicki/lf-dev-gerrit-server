#!/bin/bash
. ./env.sh
usr=$(cat ./username.${STAGE}.secret)
key_path=$(cat ./private-key-path.${STAGE}.secret)
domain="$(cat ./domain.${STAGE}.secret)"
ssh -o Port=29418 -i "${key_path}" "${usr}@ssh.${domain}" gerrit "$*"
