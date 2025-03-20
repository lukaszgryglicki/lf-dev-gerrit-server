#!/bin/bash
. ./env.sh
key_path=$(cat ../private-key-path.${STAGE}.secret)
domain="$(cat ../domain.${STAGE}.secret)"
GIT_SSH_COMMAND="ssh -i \"${key_path}\" -o IdentitiesOnly=yes" git -c "user.name=$(cat ../fullname.${STAGE}.secret)" -c "user.email=$(cat ../email.${STAGE}.secret)" push -f "ssh://admin@ssh.${domain}:29418/All-Projects" HEAD:refs/meta/config
