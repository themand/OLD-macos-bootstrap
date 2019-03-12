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

H2 "shamir-sharing"
SHAMIR_TMPDIR="${TMPDIR}$(uuidgen)"
mkdir -p $SHAMIR_TMPDIR
H3 "Downloading..."
curl -L -o ${SHAMIR_TMPDIR}/macos-shamir-split https://github.com/themand/shamir-sharing/releases/download/v1.0.0/macos-shamir-split > /dev/null
curl -L -o ${SHAMIR_TMPDIR}/macos-shamir-restore https://github.com/themand/shamir-sharing/releases/download/v1.0.0/macos-shamir-restore > /dev/null
H3 "Verifying checksums..."
SHAMIR_VALID_SPLIT="4a0e6ecea4f3bdb7c919a0a26fc8fc0b0ec19d43a512dfa3d4d368b40e080ab4"
SHAMIR_VALID_RESTORE="6189b9e22b0e938f1239f5ffa295b508564b09d93e0a5fcae5ce2ac26d58f718"
SHAMIR_SHA_SPLIT=$(shasum -p -a 256 $SHAMIR_TMPDIR/macos-shamir-split | cut -d' ' -f1)
SHAMIR_SHA_RESTORE=$(shasum -p -a 256 $SHAMIR_TMPDIR/macos-shamir-restore | cut -d' ' -f1)
if [[ "$SHAMIR_SHA_SPLIT" == "$SHAMIR_VALID_SPLIT" ]] \
&& [[ "$SHAMIR_SHA_RESTORE" == "$SHAMIR_VALID_RESTORE" ]]; then
    H3 "Installing..."
    sudo mv ${SHAMIR_TMPDIR}/macos-shamir-split /usr/local/bin/shamir-split
    sudo mv ${SHAMIR_TMPDIR}/macos-shamir-restore /usr/local/bin/shamir-restore
    sudo chmod +x /usr/local/bin/shamir-split /usr/local/bin/shamir-restore
else
    H2WARN "Checksums invalid. Not installing. Deleting downloaded files"
    H3 "macos-shamir-split downloaded sha256   : ${SHAMIR_SHA_SPLIT}"
    H3 "macos-shamir-split valid sha256        : ${SHAMIR_VALID_SPLIT}"
    H3 "macos-shamir-restore downloaded sha256 : ${SHAMIR_SHA_RESTORE}"
    H3 "macos-shamir-restore valid sha256      : ${SHAMIR_VALID_RESTORE}"
fi
rm -R "$SHAMIR_TMPDIR"
