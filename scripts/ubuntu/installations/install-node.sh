#!/usr/bin/env bash
set -e

# Load colors
SCRIPT_DIR="$(dirname "$(dirname "$(readlink -f "$0")")")" 
source "$SCRIPT_DIR/../../shared/colors.sh"

# Ubuntu-specific: Install libatomic1 before Node.js
print_step "Installing Ubuntu dependencies..."
sudo apt install -y libatomic1 > /dev/null 2>&1
print_success "Dependencies installed"

# Use shared installation script
source "$SCRIPT_DIR/../../shared/unix-base-installation/install-node.sh"
