#!/usr/bin/env bash

set -euo pipefail
. ${0%/*}/../includes/functions.sh

H1 /etc/hosts blacklist
H2 Installing script
sudo mkdir -p /usr/local/bin
sudo cp ${0%/*}/hosts/hosts-update.sh /usr/local/bin/hosts-update
if [[ ! -f "/etc/hosts_permanent" ]]; then
    sudo cp /etc/hosts /etc/hosts_permanent
fi

H2 "Scheduling daily execution via launchd (logging to /var/log/hosts-update.log)"
if [[ $(sudo launchctl list | grep com.github.themand.macos-bootstrap.hosts-update) && -f "/Library/LaunchAgents/com.github.themand.macos-bootstrap.hosts-update.plist" ]]; then
    H3 "Stopping already running launch agent"
    sudo launchctl unload /Library/LaunchAgents/com.github.themand.macos-bootstrap.hosts-update.plist
fi
sudo cp ${0%/*}/hosts/com.github.themand.macos-bootstrap.hosts-update.plist /Library/LaunchAgents/
sudo launchctl load /Library/LaunchAgents/com.github.themand.macos-bootstrap.hosts-update.plist
H3 OK
