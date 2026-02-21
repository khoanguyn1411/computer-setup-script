#!/usr/bin/env bash
set -e

SCRIPT_DIR="$(dirname "$(readlink -f "$0")")"
INSTALLATIONS_DIR="$SCRIPT_DIR/installations"

# Load colors and utilities
source "$SCRIPT_DIR/../../shared/colors.sh"
source "$SCRIPT_DIR/../../shared/utils.sh"

# Accept parameter: local (default) or ci
SETUP_ENV="${1:-local}"
if [ "$SETUP_ENV" != "local" ] && [ "$SETUP_ENV" != "ci" ]; then
	print_error "Invalid parameter: $SETUP_ENV"
	echo "Usage: $0 [local|ci]"
	echo "  local (default): Skip CUDA if no GPU detected"
	echo "  ci: Always install CUDA"
	exit 1
fi
export SETUP_ENV

print_header "DEV ENV SETUP (ZSH / NODE / DOCKER / CUDA / BUILD TOOLS)"

### 1. Install Zsh & Oh My Zsh
print_step "[1/9] Installing Zsh & Oh My Zsh..."
bash "$INSTALLATIONS_DIR/install-zsh.sh"
echo ""

### 2. Install NVM, Node, Yarn, Angular CLI
print_step "[2/9] Installing Node.js environment..."
bash "$INSTALLATIONS_DIR/install-node.sh"
echo ""

### 3. GitHub SSH config
print_step "[3/9] Setting up GitHub SSH..."
bash "$INSTALLATIONS_DIR/install-github-ssh.sh"
echo ""

### 4. Install Docker
print_step "[4/9] Installing Docker..."
bash "$INSTALLATIONS_DIR/install-docker.sh"
echo ""

### 5. Install CUDA Toolkit
if is_ci; then
	print_step "[5/9] Installing CUDA Toolkit (CI mode - always install)..."
else
	print_step "[5/9] Installing CUDA Toolkit (local mode - skip if no GPU)..."
fi
bash "$INSTALLATIONS_DIR/install-cuda.sh"
echo ""

### 6. Install IDEs
print_step "[6/9] Installing IDEs (VSCode, Windsurf, Antigravity)..."
bash "$INSTALLATIONS_DIR/install-ide.sh"
echo ""

### 7. Install Google Chrome
print_step "[7/9] Installing Google Chrome..."
bash "$INSTALLATIONS_DIR/install-chrome.sh"
echo ""

### 8. Install Audio Utilities (WSL only)
print_step "[8/9] Installing Audio Utilities (WSL only)..."
bash "$INSTALLATIONS_DIR/install-audio.sh"
echo ""

### 9. Install Build Tools
print_step "[9/9] Installing Build Tools..."
bash "$INSTALLATIONS_DIR/install-build-essential.sh"
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