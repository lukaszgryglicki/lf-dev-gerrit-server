#!/bin/bash
. ./env.sh
usr=$(cat ../username.${STAGE}.secret)
key_path=$(cat ../private-key-path.${STAGE}.secret)
domain="$(cat ../domain.${STAGE}.secret)"
scp -i "${key_path}" -p -P 29418 "${usr}@ssh.${domain}:hooks/commit-msg" .git/hooks/
