#!/bin/bash

if [ "$(uname)" != "Linux" ]; then
  exit 0
fi

DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
DOTFILES_DIR=$(dirname $DIR)

sudo apt-get install -qq -y dconf-cli

$DOTFILES_DIR/config/gnome-terminal-colors-solarized/install.sh