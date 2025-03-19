#!/bin/bash
key_path=$(cat ./private-key-path.secret)
ssh -o Port=29418 -i "${key_path}" "admin@ssh.gerrit.dev.platform.linuxfoundation.org" gerrit "$*"
