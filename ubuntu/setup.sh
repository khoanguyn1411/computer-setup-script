#!/usr/bin/env bash
set -e

SCRIPT_DIR="$(dirname "$(readlink -f "$0")")"
INSTALLATIONS_DIR="$SCRIPT_DIR/installations"

echo "======================================"
echo "  DEV ENV SETUP (ZSH / NODE / DOCKER)  "
echo "======================================"
echo ""

### 1. Install Zsh & Oh My Zsh
bash "$INSTALLATIONS_DIR/install-zsh.sh"
echo ""

### 2. Install NVM, Node, Yarn, Angular CLI
bash "$INSTALLATIONS_DIR/install-node.sh"
echo ""

### 3. GitHub SSH config
bash "$INSTALLATIONS_DIR/install-github-ssh.sh"
echo ""

### 4. Install Docker
bash "$INSTALLATIONS_DIR/install-docker.sh"
echo ""

### 5. Setup Windsurf
bash "$INSTALLATIONS_DIR/install-windsurf.sh"
echo ""

### 6. Setup Antigravity
bash "$INSTALLATIONS_DIR/install-antigravity.sh"
echo ""

### DONE
echo ""
echo "======================================"
echo " SETUP COMPLETED 🎉"
echo "======================================"
echo ""
echo "NEXT STEPS (IMPORTANT):"
echo "1️⃣  Log out & log back in (Zsh + Docker group)"
echo "2️⃣  Open ~/.zshrc and paste your Zsh config"
echo "3️⃣  Copy SSH key to GitHub:"
echo "    cat ~/.ssh/personal.pub"
echo "4️⃣  (Optional) Install powerlevel10k"
echo ""