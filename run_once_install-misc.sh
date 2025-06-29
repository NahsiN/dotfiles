#!/bin/bash

# Got from copilot.microsoft.com

set -euo pipefail

# --- Spacemacs Setup ---
if [ -d "$HOME/.emacs.d" ]; then
  if [ -d "$HOME/.emacs.d/.git" ] && grep -q "syl20bnr/spacemacs" "$HOME/.emacs.d/.git/config"; then
    echo "Updating existing Spacemacs repo..."
    git -C "$HOME/.emacs.d" pull
  else
    echo "Existing .emacs.d is not Spacemacs; skipping clone."
  fi
else
  echo "Cloning Spacemacs into ~/.emacs.d..."
  git clone https://github.com/syl20bnr/spacemacs "$HOME/.emacs.d"
fi

# --- Atuin Setup ---
if command -v atuin >/dev/null 2>&1; then
  echo "Atuin is already installed at $(command -v atuin)"
else
  echo "Installing Atuin using official install script..."
  curl --proto '=https' --tlsv1.2 -LsSf https://setup.atuin.sh | sh
  source $HOME/.atuin/bin/env
fi
