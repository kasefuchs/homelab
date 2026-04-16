#!/usr/bin/env sh
set -e

if [ ! -f /var/lib/bind/db.homelab.local ]; then
    cp -n /templates/db.homelab.local /var/lib/bind/db.homelab.local
fi

named -u bind -f -c /etc/bind/named.conf -L /var/log/bind/default.log
