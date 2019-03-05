#!/usr/bin/env bash

set -euo pipefail
. ${0%/*}/../includes/functions.sh

H1 "Installing dotfiles to home directory"
cp -r $(echo ${0%/*} | sed 's/scripts/dotfiles/')/ ~/
