#!/usr/bin/env bash

set -euo pipefail

. ${0%/*}/includes/functions.sh

H1 "This script will configure your macOS and install development tools."
yesno "Do you want to start?"

if ! $YESNO; then
    H1 "Bootstrap aborted"
    exit 1
fi

${0%/*}/scripts/macos.sh || err
${0%/*}/scripts/dotfiles.sh || err
${0%/*}/scripts/hosts.sh || err
${0%/*}/scripts/jq.sh || err
${0%/*}/scripts/chrome.sh || err
${0%/*}/scripts/webstorm.sh || err

H1 "Bootstrap finished!"
H1 "System restart recommended"
