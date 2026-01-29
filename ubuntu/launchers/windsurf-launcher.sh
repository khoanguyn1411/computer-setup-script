#!/bin/bash
CURRENT_PATH=$(readlink -f "$1")
DISTRO=$WSL_DISTRO_NAME
windsurf --folder-uri "vscode-remote://wsl+$DISTRO$CURRENT_PATH"
