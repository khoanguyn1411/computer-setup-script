#!/usr/bin/env bash
set -e

SCRIPT_DIR="$(dirname "$(readlink -f "$0")")"
INSTALLATIONS_DIR="$SCRIPT_DIR/installations"

# Load colors
source "$SCRIPT_DIR/../../shared/colors.sh"

print_header "DEV ENV SETUP (ZSH / NODE / DOCKER)"

### 1. Install Zsh & Oh My Zsh
print_step "[1/5] Installing Zsh & Oh My Zsh..."
bash "$INSTALLATIONS_DIR/install-zsh.sh"
echo ""

### 2. Install NVM, Node, Yarn, Angular CLI
print_step "[2/5] Installing Node.js environment..."
bash "$INSTALLATIONS_DIR/install-node.sh"
echo ""

### 3. GitHub SSH config
print_step "[3/5] Setting up GitHub SSH..."
bash "$INSTALLATIONS_DIR/install-github-ssh.sh"
echo ""

### 4. Install Docker
print_step "[4/5] Installing Docker..."
bash "$INSTALLATIONS_DIR/install-docker.sh"
echo ""

### 5. Install IDEs
print_step "[5/5] Installing IDEs (VSCode, Windsurf, Antigravity)..."
bash "$INSTALLATIONS_DIR/install-ide.sh"
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