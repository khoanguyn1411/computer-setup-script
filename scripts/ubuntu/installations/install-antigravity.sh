#!/usr/bin/env bash
set -e

# Load colors
SCRIPT_DIR="$(dirname "$(dirname "$(readlink -f "$0")")")" 
source "$SCRIPT_DIR/../shared/colors.sh"

print_header "SETTING UP ANTIGRAVITY LAUNCHER"

### Setup Antigravity
print_step "Creating Antigravity launcher..."

LAUNCHER_DIR="$(dirname "$(dirname "$(readlink -f "$0")")")/launchers"
mkdir -p "$LAUNCHER_DIR"

cat <<'EOF' > "$LAUNCHER_DIR/antigravity-launcher.sh"
#!/bin/bash
set -e

# Default to current directory if no path provided
TARGET_PATH="${1:-.}"

AG_EXE=$(find /mnt/*/App/antigravity -name "antigravity" -type f -executable 2>/dev/null | head -n 1)

if [ -z "$AG_EXE" ]; then
  echo "Error: Antigravity executable not found"
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

"$AG_EXE" --remote wsl+$DISTRO_NAME "$CURRENT_PATH"
EOF

chmod +x "$LAUNCHER_DIR/antigravity-launcher.sh"

# Copy launcher to home directory for easy access
cp "$LAUNCHER_DIR/antigravity-launcher.sh" ~/antigravity-launcher.sh
chmod +x ~/antigravity-launcher.sh

print_done "Antigravity launcher setup complete!"
print_info "Use 'ag [path]' to open folders in Antigravity (defaults to current directory)"
