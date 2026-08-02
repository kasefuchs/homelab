#!/usr/bin/env sh
set -euo pipefail

exec /usr/local/bin/gomplate \
  -f /templates/db.tpl -o "/var/lib/bind/db.${ZONE_NAME}" \
  -f /templates/named.conf.tpl -o /etc/bind/named.conf \
  -- named -u bind -f -c /etc/bind/named.conf -L /var/log/bind/default.log
