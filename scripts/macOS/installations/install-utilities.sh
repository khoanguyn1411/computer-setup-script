#!/usr/bin/env bash
set -e

# Load colors
SCRIPT_DIR="$(dirname "$(dirname "$(cd "$(dirname "$0")" && pwd)")")"
source "$SCRIPT_DIR/../shared/colors.sh"

print_header "INSTALLING UTILITY APPLICATIONS"

# Check if Homebrew is installed
if ! command -v brew &> /dev/null; then
    print_error "Homebrew is not installed. Please install Homebrew first."
    exit 1
fi

# System Utilities
print_step "Installing System Utilities..."
brew install lvillani/tap/chai
print_success "chai"

# System Enhancement Tools
print_step "Installing System Enhancement Tools..."
brew install --cask aldente
print_success "aldente"
brew install --cask scroll-reverser
print_success "scroll-reverser"
brew install --cask betterdisplay
print_success "betterdisplay"
brew install --cask alt-tab
print_success "alt-tab"
brew install --cask bartender
print_success "bartender"

# Cloud Storage
print_step "Installing Cloud Storage..."
brew install --cask google-drive
print_success "google-drive"

# Browsers
print_step "Installing Browsers..."
brew install --cask google-chrome
print_success "google-chrome"

# Terminals & Shells
print_step "Installing Terminals & Shells..."
brew install --cask warp
print_success "warp"

# Security & Authentication
print_step "Installing Security & Authentication..."
brew install --cask bitwarden
print_success "bitwarden"

# AI & Productivity
print_step "Installing AI & Productivity Tools..."
brew install --cask chatgpt
print_success "chatgpt"
brew install --cask antigravity
print_success "antigravity"

# Development Tools
print_step "Installing Development Tools..."
brew install --cask dbeaver-community
print_success "dbeaver-community"
brew install --cask visual-studio-code
print_success "visual-studio-code"

# Office Applications
print_step "Installing Office Applications..."
brew install --cask microsoft-office
print_success "microsoft-office"

print_done "Utility applications installation complete!"