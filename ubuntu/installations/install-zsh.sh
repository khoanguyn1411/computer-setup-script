#!/usr/bin/env bash
set -e

echo "======================================"
echo "  INSTALLING ZSH & OH MY ZSH"
echo "======================================"

### Install Zsh & Oh My Zsh
echo ">> Installing Zsh..."
sudo DEBIAN_FRONTEND=noninteractive apt update
sudo DEBIAN_FRONTEND=noninteractive apt install -y zsh git curl

if [ "$SHELL" != "$(which zsh)" ]; then
  echo ">> Setting Zsh as default shell"
  chsh -s "$(which zsh)"
fi

if [ ! -d "$HOME/.oh-my-zsh" ]; then
  echo ">> Installing Oh My Zsh"
  sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
fi

### Install Zsh plugins
echo ">> Installing Zsh plugins..."

ZSH_CUSTOM=${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}

git clone https://github.com/agkozak/zsh-z.git \
  $ZSH_CUSTOM/plugins/zsh-z || true

git clone https://github.com/zsh-users/zsh-autosuggestions.git \
  $ZSH_CUSTOM/plugins/zsh-autosuggestions || true

git clone https://github.com/zsh-users/zsh-syntax-highlighting.git \
  $ZSH_CUSTOM/plugins/zsh-syntax-highlighting || true

### Apply Zsh configuration
echo ">> Applying Zsh configuration..."

SCRIPT_DIR="$(dirname "$(dirname "$(readlink -f "$0")")")"
ZSH_CONFIG_FILE="$SCRIPT_DIR/zsh-config.sh"

if [ -f "$ZSH_CONFIG_FILE" ]; then
  echo ">> Copying configuration from zsh-config.sh to ~/.zshrc"
  cp "$ZSH_CONFIG_FILE" "$HOME/.zshrc"
  echo ">> Configuration applied successfully!"
else
  echo "⚠️  Warning: zsh-config.sh not found at $ZSH_CONFIG_FILE"
  echo "   Skipping configuration copy."
fi

echo "✅ Zsh installation complete!"
