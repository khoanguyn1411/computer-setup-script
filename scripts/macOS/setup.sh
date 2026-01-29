#!/usr/bin/env bash
set -e

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
INSTALLATIONS_DIR="$SCRIPT_DIR/installations"

# Load colors
source "$SCRIPT_DIR/utils/colors.sh"

print_header "DEV ENV SETUP FOR macOS"

### 1. Install Homebrew
print_step "[1/5] Installing Homebrew..."
bash "$INSTALLATIONS_DIR/install-homebrew.sh"
echo ""

### 2. Install Zsh & Oh My Zsh
print_step "[2/5] Installing Zsh & Oh My Zsh..."
bash "$INSTALLATIONS_DIR/install-zsh.sh"
echo ""

### 3. Install NVM, Node, Yarn, Angular CLI
print_step "[3/5] Installing Node.js environment..."
bash "$INSTALLATIONS_DIR/install-node.sh"
echo ""

### 4. GitHub SSH config
print_step "[4/5] Setting up GitHub SSH..."
bash "$INSTALLATIONS_DIR/install-github-ssh.sh"
echo ""

### 5. Install Docker
print_step "[5/5] Installing Docker..."
bash "$INSTALLATIONS_DIR/install-docker.sh"
echo ""

### DONE
echo ""
print_header "SETUP COMPLETED 🎉"
echo ""
print_info "NEXT STEPS (IMPORTANT):"
echo -e "  ${YELLOW}1️⃣${NC}  Restart your terminal (Zsh changes)"
echo -e "  ${YELLOW}2️⃣${NC}  Zsh config has been applied automatically"
echo -e "  ${YELLOW}3️⃣${NC}  Copy SSH key to GitHub:"
echo -e "      ${CYAN}cat ~/.ssh/personal.pub${NC}"
echo -e "  ${YELLOW}4️⃣${NC}  Open Docker Desktop from Applications"
echo -e "  ${YELLOW}5️⃣${NC}  (Optional) Install powerlevel10k theme"
echo ""
