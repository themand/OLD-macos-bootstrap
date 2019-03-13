#!/usr/bin/env bash

set -euo pipefail
. ${0%/*}/../includes/functions.sh

H2 "Installing chrome-autoconfig"
sudo cp ${0%/*}/../scripts/chrome-autoconfig.sh /usr/local/bin/chrome-autoconfig
sudo mkdir -p /usr/local/etc
sudo cp ${0%/*}/../scripts/assets/chrome-autoconfig/chrome-autoconfig.json /usr/local/etc
