#!/usr/bin/env bash

set -euo pipefail
. ${0%/*}/../includes/functions.sh

if [[ -z "${1-}" ]]; then
    yesno "No profile directory specified. Proceed with Default?"
    if [[ "$YESNO" == "false" ]]; then
        H2WARN Aborting
        exit 1
    fi
    PROFILE=Default
else
    PROFILE="$1"
fi

H2 "Configuring Chrome global settings..."
H3 "Use the system-native print preview dialog"
defaults write com.google.Chrome DisablePrintPreview -bool true
H3 "Expand the print dialog by default"
defaults write com.google.Chrome PMPrintingExpandedStateForPrint2 -bool true

H2 "Configuring profile $PROFILE"

DIR=~/Library/Application\ Support/Google/Chrome/$PROFILE
mkdir -p "$DIR"

if [ -f "$DIR/Preferences" ]; then
    jq -s '.[0] * .[1]' "$DIR"/Preferences ${0%/*}/chrome/Preferences.json > "$DIR"/Preferences.tmp
    mv "$DIR"/Preferences.tmp "$DIR"/Preferences
else
    cp ${0%/*}/chrome/Preferences.json "$DIR"/Preferences
fi

H3 "Disabled saving passwords and automatic logging in"
H3 "Enabled do not track"
H3 "Disabled alternative error pages"
H3 "Disabled saving credit cards data"
H3 "Disabled web forms autocomplete"
H3 "Always showing bookmark bar, but without applications shortcut"
H3 "Don't allow websites to install as protocol handler"
H3 "Accept English and Polish languages"
H3 "Offer to translate from languages other than accepted"
H3 "Disabled navigation prediction"
H3 "Disabled Flash"
H3 "Enabled popups blocking"
H3 "Disabled MIDI access"
H3 "Disabled installing payment handlers by websites"
H3 "Enabled safe browsing, but without reporting to Google"
H3 "Disabled search suggestions"
H3 "Disabled signing in to Chrome when signing into Google accounts"
H3 "Disabled online spellcheck"
H3 "Disabled websites checking for installed payment methods"
