#!/bin/bash
set -e

if [ "$1" = 'couchdb' ]; then
  # we need to set the permissions here because docker mounts volumes as root
  paths=(
    /data
    /usr/local/etc/couchdb
    /usr/local/var/lib/couchdb \
    /usr/local/var/log/couchdb \
    /usr/local/var/run/couchdb
  )

  for path in ${paths[*]}; do
    chown -R couchdb:couchdb "$path"
    chmod 0770 "$path"
    find "$path" -type d -exec chmod 775 {} \;
    find "$path" -type f -exec chmod 664 {} \;
  done

  HOME=/data sudo -i -u couchdb couchdb "$@"
fi

exec "$@"

