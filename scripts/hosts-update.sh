#!/usr/bin/env bash

set -euo pipefail

if [ $(whoami) != "root" ]; then
    (>&2 echo -e $(date +%FT%T%z)"\tERROR\thosts-update needs to be run by root")
    exit 1
fi

if [[ ! -f "/etc/hosts_permanent" ]]; then
    (>&2 echo -e $(date +%FT%T%z)"\tERROR\tHosts not updated. /etc/hosts_permanent does not exists")
    exit 2
fi

TMPFILE="/tmp/hosts-update-$(uuidgen)"
(
    echo "# ==== WARNING: Do not edit hosts, as it will be overwritten soon"
    echo "# ==== Instead: Edit /etc/hosts_permanent file and then run hosts-update"
    echo "# ---------- Contents of /etc/hosts_permanent" && \
    cat /etc/hosts_permanent && \
    echo "# ---------- Blacklist from https://raw.githubusercontent.com/StevenBlack/hosts/master/hosts" && \
    curl -s https://raw.githubusercontent.com/StevenBlack/hosts/master/hosts | grep -E "^0.0.0.0|^#|^$"
) | tee $TMPFILE > /dev/null

mv $TMPFILE /etc/hosts
dscacheutil -flushcache
killall -HUP mDNSResponder

echo -e $(date +%FT%T%z)"\tOK\tHosts updated. "$(cat /etc/hosts | wc -l | xargs)" lines in /etc/hosts"
