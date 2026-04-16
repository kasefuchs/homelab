#!/usr/bin/env sh
set -e

if [ ! -f /var/lib/bind/db.kind.local ]; then
    cp -n /templates/db.kind.local /var/lib/bind/db.kind.local
fi

chown -R 53:53 /var/lib/bind
chmod -R 775 /var/lib/bind
