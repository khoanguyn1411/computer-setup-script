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

SHARED_CONFIG_FILE="$SCRIPT_DIR/../../shared/zsh-config.sh"
OS_CONFIG_FILE="$SCRIPT_DIR/zsh-config.sh"

if [ -f "$SHARED_CONFIG_FILE" ] && [ -f "$OS_CONFIG_FILE" ]; then
  # Combine shared and OS-specific configs into single .zshrc
  cat "$SHARED_CONFIG_FILE" > "$HOME/.zshrc"
  echo "" >> "$HOME/.zshrc"
  echo "# Ubuntu specific configurations" >> "$HOME/.zshrc"
  # Skip the "Load shared" section from OS config and append the rest
  tail -n +3 "$OS_CONFIG_FILE" >> "$HOME/.zshrc"
  print_success "Configuration applied (shared + Ubuntu-specific)"
elif [ -f "$SHARED_CONFIG_FILE" ]; then
  cp "$SHARED_CONFIG_FILE" "$HOME/.zshrc"
  print_success "Shared configuration applied"
else
  print_warning "Configuration files not found"
  print_warning "Skipping configuration copy"
fi

print_done "Zsh installation complete!"
