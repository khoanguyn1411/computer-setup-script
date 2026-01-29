#!/bin/bash

# Check if running in WSL
if ! grep -qi microsoft /proc/version 2>/dev/null && [ -z "$WSL_DISTRO_NAME" ]; then
  echo "Error: This script can only be executed in a WSL (Windows Subsystem for Linux) environment."
  echo "It will not run on native Ubuntu systems."
  exit 1
fi

ag() {
    local DISTRO=$WSL_DISTRO_NAME
    local AG_EXE=$(find /mnt/*/App/antigravity -name "antigravity" -type f -executable 2>/dev/null | head -n 1)
    
    if [ -z "$AG_EXE" ]; then
        echo "Error: Antigravity executable not found"
        return 1
    fi
    
    "$AG_EXE" --remote wsl+$DISTRO "$(pwd)"
}