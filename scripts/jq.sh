#!/usr/bin/env bash

set -euo pipefail
. ${0%/*}/../includes/functions.sh

H1 "jq"
H2 "Installing..."
sudo mkdir -p /usr/local/bin
sudo mkdir -p /usr/local/share/man/man1

sudo cp ${0%/*}/../bin/jq /usr/local/bin
sudo cp ${0%/*}/../man/jq.1 /usr/local/share/man/man1
H2 "Verifying..."
echo '{}' | jq > /dev/null
H3 "OK"
