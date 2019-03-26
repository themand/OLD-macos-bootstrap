#!/usr/bin/env bash

set -euo pipefail
. ${0%/*}/../includes/functions.sh

H2 "shamir-sharing"
SHAMIR_VER="v1.0.2"
if [ $(curl -s https://api.github.com/repos/themand/shamir-sharing/releases/latest | jq -r ".name") != "$SHAMIR_VER" ]; then
    H2WARN "Newer shamir-sharing version found ("$(curl -s https://api.github.com/repos/themand/shamir-sharing/releases/latest | jq -r ".name")"). Installing known $SHAMIR_VER, please check for upgrade"
fi
SHAMIR_TMPDIR="${TMPDIR}$(uuidgen)"
mkdir -p $SHAMIR_TMPDIR
H3 "Downloading..."
curl -sSL -o ${SHAMIR_TMPDIR}/macos-shamir-split https://github.com/themand/shamir-sharing/releases/download/v1.0.2/macos-shamir-split
curl -sSL -o ${SHAMIR_TMPDIR}/macos-shamir-restore https://github.com/themand/shamir-sharing/releases/download/v1.0.2/macos-shamir-restore
H3 "Verifying checksums..."
SHAMIR_VALID_SPLIT="13d83ab7106a3dd63b5c7fdcfde49f18d9d33a3328bb4956b900dd845ef3c778"
SHAMIR_VALID_RESTORE="1caded9c2445fbbdcbe001e30231f586fe85e2501e1135371c120586c2936ce2"
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
