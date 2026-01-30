#!/usr/bin/env bash
set -e

# Load colors
SCRIPT_DIR="$(dirname "$(dirname "$(cd "$(dirname "$0")" && pwd)")")"
source "$SCRIPT_DIR/../../shared/colors.sh"

print_header "INSTALLING HOMEBREW"

if ! command -v brew &> /dev/null; then
  print_step "Installing Homebrew..."
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
  print_success "Homebrew installed"
  
  # Add Homebrew to PATH for Apple Silicon Macs
  if [[ $(uname -m) == 'arm64' ]]; then
    echo 'eval "$(/opt/homebrew/bin/brew shellenv)"' >> ~/.zprofile
    eval "$(/opt/homebrew/bin/brew shellenv)"
  fi
else
  print_info "Homebrew already installed"
fi

print_step "Updating Homebrew..."
brew update > /dev/null 2>&1
print_success "Homebrew updated"

print_done "Homebrew installation complete!"
