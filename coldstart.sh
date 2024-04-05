#!/bin/bash

# This file is used to cold boostrap yadm for dotfiles
# It will install yadm and the necessary dependencies
# Then yadm bootstrap will take over

YADM_DOTFILES_REPO=git@github.com:mxafi/dotfiles.git

function yadm_clone() {
  if [[ -d "$HOME/.local/share/yadm/repo.git" ]]; then
    echo "Dotfiles already cloned using yadm. Exiting."
    exit 0
  fi
  echo "Cloning dotfiles using yadm."
  yadm clone --bootstrap $YADM_DOTFILES_REPO
}

# Check if yadm is installed
if hash yadm &>/dev/null; then
  echo "yadm already installed, skipping installation."
  yadm_clone
  exit 0
fi

# Determine OS
if [[ "$OSTYPE" == "linux-gnu" ]]; then
  OS="linux"
elif [[ "$OSTYPE" == "darwin"* ]]; then
  OS="mac"
else
  echo "Unsupported OS"
  exit 1
fi

# Install yadm and dependencies
if [[ "$OS" == "mac" ]]; then
  xcode-select --install || true
  if ! hash brew &>/dev/null; then
    echo "Installing Homebrew"
    NONINTERACTIVE=1 /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
  fi
  brew install git yadm transcrypt openssl
elif [[ "$OS" == "linux" ]]; then
  if hash apt-get &>/dev/null; then
    sudo apt-get update
    sudo apt-get install openssl git yadm -y
  else
    echo "Unsupported package manager"
    exit 1
  fi
fi

yadm_clone
