#!/bin/bash
. ./env.sh
key_path=$(cat ../private-key-path.${STAGE}.secret)
GIT_SSH_COMMAND="ssh -i \"${key_path}\" -o IdentitiesOnly=yes" git -c "user.name=$(cat ../fullname.${STAGE}.secret)" -c "user.email=$(cat ../email.${STAGE}.secret)" commit -asm "Update project.config"
