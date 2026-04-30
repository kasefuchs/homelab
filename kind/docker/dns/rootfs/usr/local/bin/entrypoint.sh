#!/usr/bin/env sh
set -e

if [ ! -f /var/lib/bind/db.homelab.internal ]; then
    cp -n /templates/db.homelab.internal /var/lib/bind/db.homelab.internal
fi

named -u bind -f -c /etc/bind/named.conf -L /var/log/bind/default.log
