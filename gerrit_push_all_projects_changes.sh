#!/bin/bash
usr=$(cat ../username.secret)
key_path=$(cat ../private-key-path.secret)
GIT_SSH_COMMAND="ssh -i \"${key_path}\" -o IdentitiesOnly=yes" git -c "user.name=$(cat ../fullname.secret)" -c "user.email=$(cat ../email.secret)" push -f "ssh://${usr}@ssh.gerrit.dev.platform.linuxfoundation.org:29418/All-Projects" HEAD:refs/meta/config
