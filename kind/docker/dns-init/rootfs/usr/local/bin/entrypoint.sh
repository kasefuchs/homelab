#!/usr/bin/env sh
set -e

if [ ! -f /var/lib/bind/db.homelab.local ]; then
    cp -n /templates/db.homelab.local /var/lib/bind/db.homelab.local
fi

chown -R 53:53 /var/lib/bind
chmod -R 775 /var/lib/bind
