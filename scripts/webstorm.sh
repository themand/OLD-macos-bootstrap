#!/usr/bin/env bash

set -euo pipefail
. ${0%/*}/../includes/functions.sh

H1 "Webstorm"

H2 "Detecting current newest version..."
URL=$(curl -v 'https://data.services.jetbrains.com/products/download?code=WS&platform=mac' 2>&1 | grep Location | sed 's/.*\(https.*\)/\1/')
URL=${URL%$'\r'}
VER=$(echo "$URL" | sed 's/.*-\([0-9\.]*\)\.dmg/\1/')
H3 "$VER"
H2 "Downloading from $URL ..."
DIR="$TMPDIR$(uuidgen)"
H2WARN "Debug dir $DIR"
mkdir -p $DIR/mount
curl -L -o "${DIR}/Webstorm.dmg" "${URL}"

H2 Installing...
hdiutil attach -noverify -nobrowse -mountpoint $DIR/mount $DIR/Webstorm.dmg > /dev/null
cp -r $DIR/mount/WebStorm.app /Applications
hdiutil detach $DIR/mount > /dev/null
rm -r $DIR
