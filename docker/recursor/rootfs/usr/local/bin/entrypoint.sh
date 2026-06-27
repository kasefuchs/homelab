#!/usr/bin/env sh
set -eu

exec /usr/local/bin/gomplate \
  -f /templates/Corefile.tpl -o /etc/coredns/Corefile \
  -- /usr/local/bin/coredns -conf /etc/coredns/Corefile
