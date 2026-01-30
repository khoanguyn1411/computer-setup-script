#!/usr/bin/env bash
set -e

# Load colors
SCRIPT_DIR="$(dirname "$(dirname "$(readlink -f "$0")")")" 
source "$SCRIPT_DIR/../../shared/colors.sh"

# Use shared installation script
source "$SCRIPT_DIR/../../shared/unix-base-installation/install-github-ssh.sh"
