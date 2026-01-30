#!/usr/bin/env bash
set -e

# Load colors
SCRIPT_DIR="$(dirname "$(dirname "$(readlink -f "$0")")")" 
source "$SCRIPT_DIR/../../shared/colors.sh"

print_header "INSTALLING ZSH & OH MY ZSH"

### Install Zsh & Oh My Zsh
print_step "Installing Zsh..."
sudo DEBIAN_FRONTEND=noninteractive apt update > /dev/null 2>&1
sudo DEBIAN_FRONTEND=noninteractive apt install -y zsh git curl > /dev/null 2>&1
print_success "Zsh installed"

if [ "$SHELL" != "$(which zsh)" ]; then
  print_step "Setting Zsh as default shell..."
  chsh -s "$(which zsh)"
  print_success "Zsh set as default shell"
fi

if [ ! -d "$HOME/.oh-my-zsh" ]; then
  print_step "Installing Oh My Zsh..."
  sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended > /dev/null 2>&1
  print_success "Oh My Zsh installed"
fi

### Install Zsh plugins
print_step "Installing Zsh plugins..."

ZSH_CUSTOM=${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}

git clone https://github.com/agkozak/zsh-z.git \
  $ZSH_CUSTOM/plugins/zsh-z > /dev/null 2>&1 || true

git clone https://github.com/zsh-users/zsh-autosuggestions.git \
  $ZSH_CUSTOM/plugins/zsh-autosuggestions > /dev/null 2>&1 || true

git clone https://github.com/zsh-users/zsh-syntax-highlighting.git \
  $ZSH_CUSTOM/plugins/zsh-syntax-highlighting > /dev/null 2>&1 || true

print_success "Plugins installed (zsh-z, autosuggestions, syntax-highlighting)"

### Apply Zsh configuration
print_step "Applying Zsh configuration..."

ZSH_CONFIG_FILE="$SCRIPT_DIR/zsh-config.sh"

if [ -f "$ZSH_CONFIG_FILE" ]; then
  cp "$ZSH_CONFIG_FILE" "$HOME/.zshrc"
  print_success "Configuration applied from zsh-config.sh"
else
  print_warning "zsh-config.sh not found at $ZSH_CONFIG_FILE"
  print_warning "Skipping configuration copy"
fi

print_done "Zsh installation complete!"
