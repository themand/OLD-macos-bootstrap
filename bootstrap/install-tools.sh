#!/usr/bin/env bash

set -euo pipefail
. ${0%/*}/../includes/functions.sh

H1 "Installing essential tools"
sudo mkdir -p /usr/local/bin

H2 "jq"
sudo mkdir -p /usr/local/share/man/man1
sudo cp ${0%/*}/../assets/bin/jq /usr/local/bin
sudo cp ${0%/*}/../assets/man/jq.1 /usr/local/share/man/man1
H3 "Verifying..."
echo '{}' | jq > /dev/null
H3 "OK"
