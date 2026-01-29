#!/usr/bin/env bash
set -e

SCRIPT_DIR="$(dirname "$(readlink -f "$0")")"
INSTALLATIONS_DIR="$SCRIPT_DIR/installations"

# Load colors
source "$SCRIPT_DIR/utils/colors.sh"

print_header "DEV ENV SETUP (ZSH / NODE / DOCKER)"

### 1. Install Zsh & Oh My Zsh
print_step "[1/6] Installing Zsh & Oh My Zsh..."
bash "$INSTALLATIONS_DIR/install-zsh.sh"
echo ""

### 2. Install NVM, Node, Yarn, Angular CLI
print_step "[2/6] Installing Node.js environment..."
bash "$INSTALLATIONS_DIR/install-node.sh"
echo ""

### 3. GitHub SSH config
print_step "[3/6] Setting up GitHub SSH..."
bash "$INSTALLATIONS_DIR/install-github-ssh.sh"
echo ""

### 4. Install Docker
print_step "[4/6] Installing Docker..."
bash "$INSTALLATIONS_DIR/install-docker.sh"
echo ""

### 5. Setup Windsurf
print_step "[5/6] Setting up Windsurf launcher..."
bash "$INSTALLATIONS_DIR/install-windsurf.sh"
echo ""

### 6. Setup Antigravity
print_step "[6/6] Setting up Antigravity launcher..."
bash "$INSTALLATIONS_DIR/install-antigravity.sh"
echo ""

### DONE
echo ""
print_header "SETUP COMPLETED 🎉"
echo ""
print_info "NEXT STEPS (IMPORTANT):"
echo -e "  ${YELLOW}1️⃣${NC}  Log out & log back in (Zsh + Docker group)"
echo -e "  ${YELLOW}2️⃣${NC}  Zsh config has been applied automatically"
echo -e "  ${YELLOW}3️⃣${NC}  Copy SSH key to GitHub:"
echo -e "      ${CYAN}cat ~/.ssh/personal.pub${NC}"
echo -e "  ${YELLOW}4️⃣${NC}  (Optional) Install powerlevel10k theme"
echo ""