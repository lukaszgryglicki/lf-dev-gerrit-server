#!/bin/bash
usr=$(cat ./username.secret)
key_path=$(cat ./private-key-path.secret)
ssh -o Port=29418 -i "${key_path}" "${usr}@ssh.gerrit.dev.platform.linuxfoundation.org" gerrit version
