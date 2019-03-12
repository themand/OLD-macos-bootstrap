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

H2 "genusername"
USERGEN_TMPDIR="${TMPDIR}$(uuidgen)"
mkdir -p "$USERGEN_TMPDIR"
H3 "Downloading..."
curl -sSL -o ${USERGEN_TMPDIR}/genusername.js https://raw.githubusercontent.com/themand/genusername/master/genusername.js
H3 "Verifying checksum..."
USERGEN_VALID="6992dde02d43bb03327d0f0baab77d59cae7362abafec852963ec3334005db40"
USERGEN_SHA=$(shasum -p -a 256 $USERGEN_TMPDIR/genusername.js | cut -d' ' -f1)
if [[ "$USERGEN_SHA" == "$USERGEN_VALID" ]]; then
    H3 "Installing..."
    (
        echo '#!/usr/local/bin/node'
        cat "$USERGEN_TMPDIR"/genusername.js
    ) | sudo tee /usr/local/bin/genusername > /dev/null
    sudo chmod +x /usr/local/bin/genusername
else
    H2WARN "Checksums invalid. Not installing. Deleting downloaded files"
    H3 "genusername.js downloaded sha256   : ${USERGEN_SHA}"
    H3 "genusername.js valid sha256        : ${USERGEN_VALID}"
fi
rm -R "$USERGEN_TMPDIR"
