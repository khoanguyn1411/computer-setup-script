#!/usr/bin/env bash
set -e

# Load colors
SCRIPT_DIR="$(dirname "$(dirname "$(readlink -f "$0")")")" 
source "$SCRIPT_DIR/../shared/colors.sh"

print_header "INSTALLING NVM, NODE, YARN"

### Install NVM, Node, Yarn, Angular CLI
print_step "Installing NVM..."
if [ ! -d "$HOME/.nvm" ]; then
  curl -fsSL https://raw.githubusercontent.com/creationix/nvm/master/install.sh | bash > /dev/null 2>&1
  print_success "NVM installed"
else
  print_info "NVM already installed"
fi

# Load NVM immediately
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"

print_step "Installing latest Node.js via NVM..."
sudo apt install -y libatomic1 > /dev/null 2>&1
nvm install node > /dev/null 2>&1
nvm use node > /dev/null 2>&1
NODE_VERSION=$(node --version)
print_success "Node.js $NODE_VERSION installed"

print_step "Installing global npm packages..."
npm install -g yarn > /dev/null 2>&1
print_success "Yarn installed"

npm install -g @angular/cli > /dev/null 2>&1
print_success "Angular CLI installed"

print_done "Node.js installation complete!"
