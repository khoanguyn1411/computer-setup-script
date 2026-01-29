#!/usr/bin/env bash
set -e

# Load colors
SCRIPT_DIR="$(dirname "$(dirname "$(readlink -f "$0")")")" 
source "$SCRIPT_DIR/utils/colors.sh"

print_header "INSTALLING IDEs (VSCODE, WINDSURF, ANTIGRAVITY)"

# Check if running in WSL
if grep -qi microsoft /proc/version 2>/dev/null || [ -n "$WSL_DISTRO_NAME" ]; then
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
  sudo apt update > /dev/null 2>&1
  sudo apt install -y code > /dev/null 2>&1
  print_success "VS Code installed"
else
  print_info "VS Code already installed"
fi

### Install Windsurf
print_step "Installing Windsurf..."
if ! command -v windsurf &> /dev/null; then
  # Download and install Windsurf
  wget -qO windsurf.deb "https://windsurf-stable.codeiumdata.com/linux-x64/stable" 2>/dev/null
  sudo apt install -y ./windsurf.deb > /dev/null 2>&1
  rm -f windsurf.deb
  print_success "Windsurf installed"
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
