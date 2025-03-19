#!/bin/bash
usr=$(cat ../username.secret)
key_path=$(cat ../private-key-path.secret)
scp -i "${key_path}" -p -P 29418 "${usr}@ssh.gerrit.dev.platform.linuxfoundation.org:hooks/commit-msg" .git/hooks/
