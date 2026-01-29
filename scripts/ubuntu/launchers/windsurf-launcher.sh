#!/bin/bash

# Check if running in WSL and ensure WSL_DISTRO_NAME is set
if ! grep -qi microsoft /proc/version 2>/dev/null || [ -z "$WSL_DISTRO_NAME" ]; then
  echo "Error: This script can only be executed in a WSL (Windows Subsystem for Linux) environment."
  echo "It will not run on native Ubuntu systems."
  echo "Additionally, the WSL_DISTRO_NAME environment variable must be set."
  exit 1
fi

CURRENT_PATH=$(readlink -f "$1")
DISTRO=$WSL_DISTRO_NAME
windsurf --folder-uri "vscode-remote://wsl+$DISTRO$CURRENT_PATH"
