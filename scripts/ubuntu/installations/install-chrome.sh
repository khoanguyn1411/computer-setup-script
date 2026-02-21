#!/bin/bash
# install-chrome.sh: Installs Google Chrome on Ubuntu or WSL
# Usage: sudo ./install-chrome.sh

set -e

# Set non-interactive mode for apt
export DEBIAN_FRONTEND=noninteractive

# Load colors for pretty printing
SCRIPT_DIR="$(dirname "$(readlink -f "$0")")"
source "$SCRIPT_DIR/../../../shared/colors.sh"

print_header "GOOGLE CHROME INSTALLATION"

print_step "Updating package lists..."
sudo apt-get update -y

print_step "Installing dependencies..."
sudo apt-get install -y wget gnupg lsb-release

print_step "Setting up Google Chrome repository..."
wget -q -O - https://dl-ssl.google.com/linux/linux_signing_key.pub | sudo apt-key add -
echo "deb [arch=amd64] http://dl.google.com/linux/chrome/deb/ stable main" | sudo tee /etc/apt/sources.list.d/google-chrome.list > /dev/null

print_step "Updating package lists with Chrome repository..."
sudo apt-get update -y

print_step "Installing Google Chrome..."
sudo apt-get install -y google-chrome-stable

echo ""
print_done "Google Chrome installation complete!"
echo ""

# Verify installation
if command -v google-chrome &> /dev/null; then
    CHROME_VERSION=$(google-chrome --version)
    print_success "Chrome installed: $CHROME_VERSION"
else
    print_error "Chrome installation failed"
    exit 1
fi

print_step "Cleaning up temporary packages..."
sudo apt-get clean

echo ""
print_info "Next steps:"
echo -e "  ${YELLOW}1.${NC}  Launch Chrome: ${CYAN}google-chrome${NC}"
echo ""
