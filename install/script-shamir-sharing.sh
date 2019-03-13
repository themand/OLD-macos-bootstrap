#!/usr/bin/env bash

set -euo pipefail
. ${0%/*}/../includes/functions.sh

H2 "shamir-sharing"
SHAMIR_TMPDIR="${TMPDIR}$(uuidgen)"
mkdir -p $SHAMIR_TMPDIR
H3 "Downloading..."
curl -sSL -o ${SHAMIR_TMPDIR}/macos-shamir-split https://github.com/themand/shamir-sharing/releases/download/v1.0.1/macos-shamir-split
curl -sSL -o ${SHAMIR_TMPDIR}/macos-shamir-restore https://github.com/themand/shamir-sharing/releases/download/v1.0.1/macos-shamir-restore
H3 "Verifying checksums..."
SHAMIR_VALID_SPLIT="4503738588fdcfc4ac4b5f9c2fbf873ea6a5bdcc1941b17cf24d21a546c3ac64"
SHAMIR_VALID_RESTORE="01aef891489658921f84f71c1f948eb95377b9c63a23d56d6bff5b0958fe6daf"
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
