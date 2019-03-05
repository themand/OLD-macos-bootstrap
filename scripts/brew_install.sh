#!/usr/bin/env bash

set -euo pipefail
. ${0%/*}/../includes/functions.sh

H2 "Installing Homebrew packages"

H3 "jq"
brew install jq
