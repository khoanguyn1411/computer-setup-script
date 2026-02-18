#!/usr/bin/env bash
set -e

SCRIPT_DIR="$(dirname "$(readlink -f "$0")")"
INSTALLATIONS_DIR="$SCRIPT_DIR/installations"

# Load colors
source "$SCRIPT_DIR/../../shared/colors.sh"

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

print_header "DEV ENV SETUP (ZSH / NODE / DOCKER / CUDA)"

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

### 5. Install CUDA Toolkit
if [ "$SETUP_ENV" = "ci" ]; then
	print_step "[5/6] Installing CUDA Toolkit (CI mode - always install)..."
else
	print_step "[5/6] Installing CUDA Toolkit (local mode - skip if no GPU)..."
fi
bash "$INSTALLATIONS_DIR/install-cuda.sh"
echo ""

### 5. Install IDEs
print_step "[5/5] Installing IDEs (VSCode, Windsurf, Antigravity)..."

# Step number updated to [6/6]
print_step "[6/6] Installing IDEs (VSCode, Windsurf, Antigravity)..."
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