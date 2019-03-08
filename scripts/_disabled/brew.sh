#!/usr/bin/env bash

set -euo pipefail
. ${0%/*}/../includes/functions.sh

H2WARN Homebrew installation is currently disabled

# When re-enabling, add the following to dotfiles/.bash_profile
#export HOMEBREW_NO_ANALYTICS=1
#export HOMEBREW_NO_AUTO_UPDATE=1
#export HOMEBREW_NO_GITHUB_API=1
#export HOMEBREW_NO_INSECURE_REDIRECT=1
#export HOMEBREW_CASK_OPTS=--require-sha

exit

CRON_ENTRY='0 */6 * * * /usr/local/bin/brew update &>/dev/null'

H1 "Homebrew"
H2 "Preparing Homebrew installation"
sudo -v

HOMEBREW_PREFIX="$(brew --prefix 2>/dev/null || true)"
[ -n "$HOMEBREW_PREFIX" ] || HOMEBREW_PREFIX="/usr/local"
H3 "at prefix $HOMEBREW_PREFIX"
[ -d "$HOMEBREW_PREFIX" ] || sudo mkdir -p "$HOMEBREW_PREFIX"
if [ "$HOMEBREW_PREFIX" = "/usr/local" ]
then
  sudo chown "root:wheel" "$HOMEBREW_PREFIX" 2>/dev/null || true
fi
(
  cd "$HOMEBREW_PREFIX"
  sudo mkdir -p Cellar Frameworks bin etc include lib opt sbin share var
  sudo chown -R "$USER:admin" Cellar Frameworks bin etc include lib opt sbin share var
)

HOMEBREW_REPOSITORY="$(brew --repository 2>/dev/null || true)"
[ -n "$HOMEBREW_REPOSITORY" ] || HOMEBREW_REPOSITORY="/usr/local/Homebrew"
H3 "Preparing $HOMEBREW_REPOSITORY"
[ -d "$HOMEBREW_REPOSITORY" ] || sudo mkdir -p "$HOMEBREW_REPOSITORY"
sudo chown -R "$USER:admin" "$HOMEBREW_REPOSITORY"
if [ $HOMEBREW_PREFIX != $HOMEBREW_REPOSITORY ]
then
  ln -sf "$HOMEBREW_REPOSITORY/bin/brew" "$HOMEBREW_PREFIX/bin/brew"
fi

H2 "Downloading Homebrew..."
export GIT_DIR="$HOMEBREW_REPOSITORY/.git" GIT_WORK_TREE="$HOMEBREW_REPOSITORY"
git init -q
git config remote.origin.url "https://github.com/Homebrew/brew"
git config remote.origin.fetch "+refs/heads/*:refs/remotes/origin/*"
git fetch --tags --force
git reset -q --hard origin/master
unset GIT_DIR GIT_WORK_TREE

H2 "Updating Homebrew..."
brew update

H3 "Scheduling Homebrew update every six hours via cron (you might be prompted for permission)..."
if ! crontab -l >/dev/null 2>&1; then
  echo "$CRON_ENTRY" | crontab -
else
  if ! (crontab -l | fgrep -q "$CRON_ENTRY"); then
    (crontab -l 2>/dev/null; echo "$CRON_ENTRY") | crontab -
  fi
fi

${0%/*}/brew_install.sh

H2 "Homebrew cleanup"
brew cleanup