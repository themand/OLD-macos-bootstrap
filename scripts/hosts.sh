#!/usr/bin/env bash

set -euo pipefail
. ${0%/*}/../includes/functions.sh

H1 /etc/hosts blacklist
H2 Installing script
mkdir -p ~/bin
cp ${0%/*}/hosts/hosts-update.sh ~/bin/hosts-update
H2 Downloading and installing hosts blacklist
~/bin/hosts-update

