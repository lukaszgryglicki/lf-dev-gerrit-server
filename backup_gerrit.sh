#!/bin/bash
. ./env.sh
cd /data || exit 1
mv db/*.tar . || exit 2
tar cf /config/gerrit-configured.tar etc lib git db cache index plugins || exit 3
mv *.tar db/ || exit 4
echo 'ok'
