#!/bin/bash
# install-build-essential.sh: Installs build tools on Ubuntu or WSL
# Usage: sudo ./install-build-essential.sh

set -e

# Load colors for pretty printing
SCRIPT_DIR="$(dirname "$(readlink -f "$0")")"
source "$SCRIPT_DIR/../../../shared/colors.sh"

print_header "BUILD ESSENTIAL INSTALLATION"

print_step "Updating package lists..."
sudo apt-get update

print_step "Installing build-essential..."
sudo apt-get install -y build-essential

print_step "Installing additional build tools..."
sudo apt-get install -y cmake git

echo ""
print_done "Build tools installation complete!"
echo ""
