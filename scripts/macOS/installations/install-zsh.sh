#!/usr/bin/env bash
set -e

# Load colors
SCRIPT_DIR="$(dirname "$(dirname "$(cd "$(dirname "$0")" && pwd)")")"
source "$SCRIPT_DIR/../../shared/colors.sh"

### Install Oh My Zsh
if [ ! -d "$HOME/.oh-my-zsh" ]; then
  print_step "Installing Oh My Zsh..."
  sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended > /dev/null 2>&1
  print_success "Oh My Zsh installed"
else
  print_info "Oh My Zsh already installed"
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
OS_CONFIG_FILE="$SCRIPT_DIR/macOS/zsh-config.sh"

if [ -f "$SHARED_CONFIG_FILE" ] && [ -f "$OS_CONFIG_FILE" ]; then
  # Start with Homebrew initialization from macOS config
  head -n 4 "$OS_CONFIG_FILE" > "$HOME/.zshrc"
  echo "" >> "$HOME/.zshrc"
  # Add shared config
  cat "$SHARED_CONFIG_FILE" >> "$HOME/.zshrc"
  echo "" >> "$HOME/.zshrc"
  echo "# macOS specific configurations" >> "$HOME/.zshrc"
  # Skip the Homebrew and "Load shared" sections, append the rest
  tail -n +6 "$OS_CONFIG_FILE" | tail -n +3 >> "$HOME/.zshrc"
  print_success "Configuration applied (Homebrew + shared + macOS-specific)"
elif [ -f "$SHARED_CONFIG_FILE" ]; then
  cp "$SHARED_CONFIG_FILE" "$HOME/.zshrc"
  print_success "Shared configuration applied"
else
  print_warning "Configuration files not found"
  print_warning "Skipping configuration copy"
fi

print_done "Oh My Zsh installation complete!"
