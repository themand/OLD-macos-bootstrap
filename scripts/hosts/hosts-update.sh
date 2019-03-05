#!/usr/bin/env bash

set -euo pipefail

if [ ! -f "$HOME/.hosts" ]; then
    echo "Hosts not updated. ~/.hosts does not exists"
    exit 1
fi

TMPFILE="$TMPDIR$(uuidgen)"

(
    echo "# ==== WARNING: Do not edit hosts, as it will be overwritten soon"
    echo "# ==== Instead: Edit ~/.hosts file and then run ~/bin/hosts-update"
    echo "# ---------- Contents of ~/.hosts" && \
    cat ~/.hosts && \
    echo "# ---------- Blacklist from https://raw.githubusercontent.com/StevenBlack/hosts/master/hosts" && \
    curl -s https://raw.githubusercontent.com/StevenBlack/hosts/master/hosts | grep -E "^0.0.0.0|^#|^$"
) | tee $TMPFILE > /dev/null

sudo mv $TMPFILE /etc/hosts
sudo dscacheutil -flushcache
sudo killall -HUP mDNSResponder