#!/usr/bin/env bash

set -euo pipefail
. ${0%/*}/../includes/functions.sh

H1 "Google Chrome"

H2 "Downloading from https://dl.google.com/chrome/mac/stable/GGRO/googlechrome.dmg ..."
DIR="$TMPDIR$(uuidgen)"
mkdir -p $DIR/mount
curl https://dl.google.com/chrome/mac/stable/GGRO/googlechrome.dmg > $DIR/googlechrome.dmg

H2 "Installing..."
hdiutil attach -noverify -nobrowse -mountpoint $DIR/mount $DIR/googlechrome.dmg > /dev/null
cp -R $DIR/mount/*.app /Applications
hdiutil detach $DIR/mount > /dev/null
rm -r $DIR

H2 "Configuring global settings..."
H3 "Use the system-native print preview dialog"
defaults write com.google.Chrome DisablePrintPreview -bool true
H3 "Expand the print dialog by default"
defaults write com.google.Chrome PMPrintingExpandedStateForPrint2 -bool true

${0%/*}/chrome_profile.sh