#!/bin/bash

# Check if running in WSL and ensure WSL_DISTRO_NAME is set
if ! grep -qi microsoft /proc/version 2>/dev/null || [ -z "$WSL_DISTRO_NAME" ]; then
  echo "Error: This script requires a WSL (Windows Subsystem for Linux) environment."
  echo "Requirements:"
  echo "  1. Must be running in WSL (not native Ubuntu)"
  echo "  2. WSL_DISTRO_NAME environment variable must be set"
  exit 1
fi

CURRENT_PATH=$(readlink -f "$1")
DISTRO=$WSL_DISTRO_NAME
windsurf --folder-uri "vscode-remote://wsl+$DISTRO$CURRENT_PATH"
