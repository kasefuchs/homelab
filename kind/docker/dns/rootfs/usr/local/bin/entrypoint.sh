#!/usr/bin/env sh
set -e

if [ ! -f /var/lib/bind/db.kind.homelab.test ]; then
    cp -n /templates/db.kind.homelab.test /var/lib/bind/db.kind.homelab.test
fi

named -u bind -f -c /etc/bind/named.conf -L /var/log/bind/default.log
