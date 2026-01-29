#!/usr/bin/env bash
set -e

# Load colors
SCRIPT_DIR="$(dirname "$(dirname "$(readlink -f "$0")")")" 
source "$SCRIPT_DIR/utils/colors.sh"

print_header "SETTING UP WINDSURF LAUNCHER"

# Check if running in WSL
if ! grep -qi microsoft /proc/version 2>/dev/null && [ -z "$WSL_DISTRO_NAME" ]; then
  print_warning "This launcher is only needed for WSL environments"
  print_info "On native Ubuntu, use the 'windsurf' command directly"
  print_info "Desktop shortcuts are created by install-ide.sh"
  exit 0
fi

### Setup Windsurf
print_step "Creating Windsurf launcher..."

LAUNCHER_DIR="$(dirname "$(dirname "$(readlink -f "$0")")")/launchers"
mkdir -p "$LAUNCHER_DIR"

cat <<'EOF' > "$LAUNCHER_DIR/windsurf-launcher.sh"
#!/bin/bash
set -e

if [ -z "$1" ]; then
  echo "Usage: windsurf-open <path>"
  exit 1
fi

if ! command -v windsurf >/dev/null 2>&1; then
  echo "Error: windsurf is not installed"
  exit 1
fi

CURRENT_PATH=$(readlink -f "$1")

DISTRO_NAME="$WSL_DISTRO_NAME"

windsurf --folder-uri "vscode-remote://wsl+${DISTRO_NAME}${CURRENT_PATH}"
EOF

chmod +x "$LAUNCHER_DIR/windsurf-launcher.sh"

# Copy launcher to home directory for easy access via aliases
cp "$LAUNCHER_DIR/windsurf-launcher.sh" ~/windsurf-launcher.sh

print_done "Windsurf launcher setup complete!"
print_info "Use 'wf <path>' to open folders in Windsurf"
