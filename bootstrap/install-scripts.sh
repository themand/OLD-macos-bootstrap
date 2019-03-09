#!/usr/bin/env bash

set -euo pipefail
. ${0%/*}/../includes/functions.sh

H1 "Installing custom scripts"
sudo mkdir -p /usr/local/bin

H2 "hosts-update"
sudo cp ${0%/*}/../scripts/hosts-update.sh /usr/local/bin/hosts-update
if [[ ! -f "/etc/hosts_permanent" ]]; then
    H3 "Copying /etc/hosts to /etc/hosts_permanent"
    sudo cp /etc/hosts /etc/hosts_permanent
fi

H2 "chrome-autoconfig"
sudo cp ${0%/*}/../scripts/chrome-autoconfig.sh /usr/local/bin/chrome-autoconfig
sudo mkdir -p /usr/local/etc
sudo cp ${0%/*}/../scripts/assets/chrome-autoconfig/chrome-autoconfig.json /usr/local/etc
