#!/usr/bin/env bash
set -e

echo "======================================"
echo "  INSTALLING NVM, NODE, YARN"
echo "======================================"

### Install NVM, Node, Yarn, Angular CLI
echo ">> Installing NVM..."
if [ ! -d "$HOME/.nvm" ]; then
  curl -fsSL https://raw.githubusercontent.com/creationix/nvm/master/install.sh | bash
fi

# Load NVM immediately
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"

echo ">> Installing latest Node via NVM..."
sudo apt install -y libatomic1
nvm install node
nvm use node

echo ">> Installing Yarn & Angular CLI..."
npm install -g yarn
npm install -g @angular/cli

echo "✅ Node.js installation complete!"
