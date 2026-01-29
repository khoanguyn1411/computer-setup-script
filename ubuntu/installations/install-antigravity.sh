#!/usr/bin/env bash
set -e

echo "======================================"
echo "  SETTING UP ANTIGRAVITY LAUNCHER"
echo "======================================"

### Setup Antigravity
echo ">> Installing Antigravity launcher..."

LAUNCHER_DIR="$(dirname "$(dirname "$(readlink -f "$0")")")/launchers"
mkdir -p "$LAUNCHER_DIR"

cat <<'EOF' > "$LAUNCHER_DIR/antigravity-launcher.sh"
#!/bin/bash
set -e

if [ -z "$1" ]; then
  echo "Usage: ag-open <path>"
  exit 1
fi

AG_EXE=$(find /mnt/*/App/antigravity -name "antigravity" -type f -executable 2>/dev/null | head -n 1)

if [ -z "$AG_EXE" ]; then
  echo "Error: Antigravity executable not found"
  exit 1
fi

CURRENT_PATH=$(readlink -f "$1")

DISTRO_NAME="$WSL_DISTRO_NAME"

"$AG_EXE" --remote wsl+$DISTRO_NAME "$CURRENT_PATH"
EOF

chmod +x "$LAUNCHER_DIR/antigravity-launcher.sh"

echo "✅ Antigravity launcher setup complete!"
