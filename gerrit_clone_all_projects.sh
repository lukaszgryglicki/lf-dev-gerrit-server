#!/bin/bash
. ./env.sh
usr=$(cat ./username.${STAGE}.secret)
key_path=$(cat ./private-key-path.${STAGE}.secret)
domain="$(cat ./domain.${STAGE}.secret)"
GIT_SSH_COMMAND="ssh -i \"${key_path}\" -o IdentitiesOnly=yes" git clone "ssh://${usr}@ssh.${domain}:29418/All-Projects"
