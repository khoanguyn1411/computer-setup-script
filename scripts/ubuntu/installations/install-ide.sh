#!/usr/bin/env bash
set -e

# Load colors
SCRIPT_DIR="$(dirname "$(dirname "$(readlink -f "$0")")")" 
source "$SCRIPT_DIR/../../shared/colors.sh"
source "$SCRIPT_DIR/../../shared/utils.sh"

# Set non-interactive mode for apt
export DEBIAN_FRONTEND=noninteractive

print_header "INSTALLING IDEs (VSCODE, WINDSURF, ANTIGRAVITY)"

# Check if running in WSL
if is_wsl; then
  print_warning "Running in WSL - IDEs should be installed on Windows"
  echo ""
  print_info "To install IDEs on Windows:"
  echo ""
  echo -e "  ${CYAN}VSCode:${NC}"
  echo -e "    Download from: ${BOLD}https://code.visualstudio.com/${NC}"
  echo ""
  echo -e "  ${CYAN}Windsurf:${NC}"
  echo -e "    Download from: ${BOLD}https://codeium.com/windsurf${NC}"
  echo ""
  echo -e "  ${CYAN}Antigravity:${NC}"
  echo -e "    Download from: ${BOLD}https://antigravity.com/${NC}"
  echo ""
  print_info "After installation, use the WSL remote extensions/features"
  print_info "Launchers are already configured in your Zsh config (wf, ag)"
  exit 0
fi

### Install VS Code
print_step "Installing VS Code..."
if ! command -v code &> /dev/null; then
  # Add Microsoft GPG key
  wget -qO- https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor > packages.microsoft.gpg
  sudo install -D -o root -g root -m 644 packages.microsoft.gpg /etc/apt/keyrings/packages.microsoft.gpg
  
  # Add VS Code repository
  echo "deb [arch=amd64,arm64,armhf signed-by=/etc/apt/keyrings/packages.microsoft.gpg] https://packages.microsoft.com/repos/code stable main" | \
    sudo tee /etc/apt/sources.list.d/vscode.list > /dev/null
  
  rm -f packages.microsoft.gpg
  
  # Install VS Code
  sudo apt-get update -y > /dev/null 2>&1
  sudo apt install -y code > /dev/null 2>&1
  print_success "VS Code installed"
else
  print_info "VS Code already installed"
fi

### Install Windsurf
print_step "Installing Windsurf..."
if ! command -v windsurf &> /dev/null; then
  # Install dependencies first
  sudo apt-get update -y > /dev/null 2>&1
  sudo apt install -y wget ca-certificates > /dev/null 2>&1
  
  # Download and install Windsurf
  if wget -qO windsurf.deb "https://windsurf-stable.codeiumdata.com/linux-x64/stable" 2>/dev/null; then
    # Install with fixed dependencies
    sudo apt install -y -f ./windsurf.deb > /dev/null 2>&1
    rm -f windsurf.deb
    
    if command -v windsurf &> /dev/null; then
      print_success "Windsurf installed"
    else
      print_warning "Windsurf installation completed but command not found"
      print_info "You may need to restart your session or check PATH"
    fi
  else
    print_warning "Failed to download Windsurf"
    print_info "You can install manually from: https://codeium.com/windsurf"
  fi
else
  print_info "Windsurf already installed"
fi

### Install Antigravity
print_step "Checking Antigravity installation..."
if ! command -v antigravity &> /dev/null; then
  print_warning "Antigravity installation requires manual download"
  print_info "Please visit: https://antigravity.com/ to download"
  print_info "Follow the installation instructions for your system"
else
  print_info "Antigravity already installed"
fi

print_done "IDE installation complete!"
print_info "Launch IDEs from your application menu or terminal"

# Setup launchers only in WSL
if is_wsl; then
  ### Setup Windsurf Launcher
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

  ### Setup Antigravity Launcher
  print_step "Creating Antigravity launcher..."

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
fi