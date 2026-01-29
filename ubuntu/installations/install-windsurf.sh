#!/usr/bin/env bash
set -e

echo "======================================"
echo "  SETTING UP WINDSURF LAUNCHER"
echo "======================================"

### Setup Windsurf
echo ">> Installing WindSurf launcher..."

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

echo "✅ Windsurf launcher setup complete!"
