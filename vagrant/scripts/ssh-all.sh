#!/bin/sh

for node in $(vagrant status --machine-readable | awk -F, '$3 == "state" && $4 == "running" { print $2 }' | sort -u); do
  echo "$node: $(vagrant ssh "$node" -c "$*" 2>/dev/null)"
done
