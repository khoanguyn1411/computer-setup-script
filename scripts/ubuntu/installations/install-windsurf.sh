#!/usr/bin/env bash
set -e

# Load colors
SCRIPT_DIR="$(dirname "$(dirname "$(readlink -f "$0")")")" 
source "$SCRIPT_DIR/../shared/colors.sh"

print_header "SETTING UP WINDSURF LAUNCHER"

### Setup Windsurf
print_step "Creating Windsurf launcher..."

LAUNCHER_DIR="$(dirname "$(dirname "$(readlink -f "$0")")")/launchers"
mkdir -p "$LAUNCHER_DIR"

cat <<'EOF' > "$LAUNCHER_DIR/windsurf-launcher.sh"
#!/bin/bash
set -e

# Default to current directory if no path provided
TARGET_PATH="${1:-.}"

if ! command -v windsurf >/dev/null 2>&1; then
  echo "Error: windsurf is not installed"
  exit 1
fi

# Validate WSL environment
if [ -z "$WSL_DISTRO_NAME" ]; then
  echo "Error: WSL_DISTRO_NAME is not set. This launcher is for WSL environments only."
  exit 1
fi

# Resolve the absolute path
if ! CURRENT_PATH=$(readlink -f "$TARGET_PATH" 2>/dev/null); then
  echo "Error: Invalid path '$TARGET_PATH'"
  exit 1
fi

DISTRO_NAME="$WSL_DISTRO_NAME"

windsurf --folder-uri "vscode-remote://wsl+${DISTRO_NAME}${CURRENT_PATH}"
EOF

chmod +x "$LAUNCHER_DIR/windsurf-launcher.sh"

# Copy launcher to home directory for easy access
cp "$LAUNCHER_DIR/windsurf-launcher.sh" ~/windsurf-launcher.sh
chmod +x ~/windsurf-launcher.sh

print_done "Windsurf launcher setup complete!"
print_info "Use 'wf [path]' to open folders in Windsurf (defaults to current directory)"
