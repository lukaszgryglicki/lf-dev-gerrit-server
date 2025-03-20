#!/bin/bash
. ./env.sh
cd /data || exit 1
if [ ! -f "db/gerrit.tar" ]
then
  echo "$0: you must have /data/db/gerrit.tar"
  exit 2
fi
rm -rf var || exit 3
tar xf db/gerrit.tar || exit 4
mv db/gerrit.tar . || exit 5
rm -rf db/* || exit 6
mv gerrit.tar db/ || exit 7
rm -rf /data/cache/* || exit 8
rm -rf /data/etc/* || exit 9
cp -R /data/var/gerrit/etc/* /data/etc/ || exit 10
mv lib/saml.jar . || exit 11
rm -rf lib/* || exit 12
cp -R /data/var/gerrit/lib/* /data/lib/ || exit 13
mv saml.jar lib/ || exit 14
rm -rf git/* || exit 15
rm -rf index/* || exit 16
rm -rf /data/plugins/* || exit 17
cp -R /data/var/gerrit/plugins/* /data/plugins/ || exit 18
chmod -R ugo+rwx /data || exit 19
rm -rf var || exit 20
echo "ok"
