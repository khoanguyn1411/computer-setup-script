#!/usr/bin/env bash
set -e

# Load colors
SCRIPT_DIR="$(dirname "$(dirname "$(cd "$(dirname "$0")" && pwd)")")"
source "$SCRIPT_DIR/../../shared/colors.sh"

# Use shared installation script (no macOS-specific dependencies needed)
source "$SCRIPT_DIR/../../shared/unix-base-installation/install-node.sh"
