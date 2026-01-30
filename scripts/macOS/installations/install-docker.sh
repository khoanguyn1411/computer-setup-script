#!/usr/bin/env bash
set -e

# Load colors
SCRIPT_DIR="$(dirname "$(dirname "$(cd "$(dirname "$0")" && pwd)")")"
source "$SCRIPT_DIR/../shared/colors.sh"

print_header "INSTALLING DOCKER"

print_step "Checking Docker installation..."

if ! command -v docker &> /dev/null; then
  print_step "Installing Docker via Homebrew..."
  brew install --cask docker > /dev/null 2>&1
  print_success "Docker Desktop installed"
  print_warning "Docker Desktop requires manual startup"
  print_info "Open Docker Desktop from Applications to complete setup"
else
  print_info "Docker already installed"
fi

print_done "Docker installation complete!"
print_info "Make sure Docker Desktop is running before using Docker commands"
