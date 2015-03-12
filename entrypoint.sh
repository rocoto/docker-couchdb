#!/bin/bash
set -e

if [ "$1" = 'couchdb' ]; then
  # we need to set the permissions here because docker mounts volumes as root

  mkdir -p /data/log
  mkdir -p /data/etc

  if [ ! -f /data/etc/default.ini ]; then
    cp /usr/local/etc/couchdb/default.ini /data/etc/default.ini
  fi

  if [ ! -f /data/etc/local.ini ]; then
    cp /local.ini /data/etc/local.ini
  fi

  chown -R couchdb:couchdb /data
  chmod 0770 /data
  find /data -type d -exec chmod 775 {} \;
  find /data -type f -exec chmod 664 {} \;

  HOME=/data sudo -i -u couchdb sh -c "couchdb -p /data/couchdb.pid -n -a /data/etc/default.ini -a /data/etc/local.ini"
else
  exec "$@"
fi

