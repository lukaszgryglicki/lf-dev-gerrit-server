#!/bin/bash
key_path=$(cat ../private-key-path.secret)
GIT_SSH_COMMAND="ssh -i \"${key_path}\" -o IdentitiesOnly=yes" git -c "user.name=$(cat ../fullname.secret)" -c "user.email=$(cat ../email.secret)" commit -asm "Update project.config"
