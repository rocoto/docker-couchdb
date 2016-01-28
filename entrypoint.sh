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

  cmd="couchdb -p /data/couchdb.pid -n -a /data/etc/default.ini -a /data/etc/local.ini"

  if [ -n "$COUCHDB_ADMIN_PASSWORD" ]; then
    # Add [admins] section if not present in local.ini
    if ! grep -e '^\[admins\]' /data/etc/local.ini &>/dev/null; then
      echo "" >> /data/etc/local.ini
      echo "[admins]" >> /data/etc/local.ini
    fi

    # remove admin user if already present
    grep -ve '^admin\s=' /data/etc/local.ini > /data/etc/local.ini.tmp
    rm /data/etc/local.ini
    mv /data/etc/local.ini.tmp /data/etc/local.ini

    # Add admin user
    sed -i 's,^\[admins\],[admins]\nadmin = '"$COUCHDB_ADMIN_PASSWORD"',g' /data/etc/local.ini
  fi

  chown -R couchdb:couchdb /data
  chmod 0770 /data
  find /data -type d -exec chmod 775 {} \;
  find /data -type f -exec chmod 664 {} \;

  HOME=/data sudo -i -u couchdb sh -c "$cmd"
else
  exec "$@"
fi

