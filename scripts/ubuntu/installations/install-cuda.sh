#!/bin/bash
# install-cuda.sh: Installs NVIDIA CUDA Toolkit on Ubuntu or WSL
# Usage: sudo ./install-cuda.sh

set -e

# Load colors for pretty printing
SCRIPT_DIR="$(dirname "$(readlink -f "$0")")"
source "$SCRIPT_DIR/../../../shared/colors.sh"
source "$SCRIPT_DIR/../../../shared/utils.sh"

print_header "NVIDIA CUDA TOOLKIT INSTALLATION"

# Check if we should skip CUDA installation in local mode without GPU
if is_local; then
	print_info "Local mode detected. Checking for NVIDIA GPU..."
	if ! command -v lspci &> /dev/null || ! lspci | grep -i nvidia &> /dev/null; then
		print_warning "No NVIDIA GPU detected in local mode. Skipping CUDA installation."
		echo ""
		exit 0
	fi
	print_success "NVIDIA GPU detected. Proceeding with installation."
else
	print_info "CI mode detected. Proceeding with CUDA installation."
fi

print_step "Starting CUDA Toolkit installation..."

# Set wget flags based on environment
if is_ci; then
	WGET_FLAGS="-q"
else
	WGET_FLAGS=""
fi

# Detect if running in WSL
if is_wsl; then
	print_info "Detected WSL environment. Using WSL-specific CUDA installation."
	print_step "Updating package lists..."
	sudo apt-get update
	sudo apt-get install -y wget gnupg lsb-release jq
	
	print_step "Setting up CUDA repository pin..."
	wget $WGET_FLAGS https://developer.download.nvidia.com/compute/cuda/repos/wsl-ubuntu/x86_64/cuda-wsl-ubuntu.pin
	sudo mv cuda-wsl-ubuntu.pin /etc/apt/preferences.d/cuda-repository-pin-600
	
	print_step "Downloading and installing CUDA 13.1 repository deb package..."
	wget $WGET_FLAGS https://developer.download.nvidia.com/compute/cuda/13.1.1/local_installers/cuda-repo-wsl-ubuntu-13-1-local_13.1.1-1_amd64.deb
	sudo dpkg -i cuda-repo-wsl-ubuntu-13-1-local_13.1.1-1_amd64.deb
	
	print_step "Setting up CUDA keyring..."
	sudo cp /var/cuda-repo-wsl-ubuntu-13-1-local/cuda-*-keyring.gpg /usr/share/keyrings/
	
	print_step "Updating package lists and installing CUDA Toolkit 13.1..."
	sudo apt-get update
	sudo apt-get -y install cuda-toolkit-13-1
	
	print_step "Cleaning up downloaded packages..."
	sudo rm cuda-repo-wsl-ubuntu-13-1-local_13.1.1-1_amd64.deb
else
	print_info "Detected native Ubuntu environment. Using standard CUDA installation."
	UBUNTU_VERSION=$(lsb_release -sr)
	UBUNTU_VERSION_NO_DOT=$(echo "$UBUNTU_VERSION" | sed -e 's/\.//')
	print_info "Detected Ubuntu version: $UBUNTU_VERSION"
	
	print_step "Updating package lists..."
	sudo apt-get update
	sudo apt-get install -y wget gnupg lsb-release jq
	
	print_step "Setting up CUDA repository pin..."
	wget $WGET_FLAGS https://developer.download.nvidia.com/compute/cuda/repos/ubuntu${UBUNTU_VERSION_NO_DOT}/x86_64/cuda-ubuntu${UBUNTU_VERSION_NO_DOT}.pin
	sudo mv cuda-ubuntu${UBUNTU_VERSION_NO_DOT}.pin /etc/apt/preferences.d/cuda-repository-pin-600
	
	print_step "Downloading and installing CUDA 13.1 repository deb package..."
	wget $WGET_FLAGS https://developer.download.nvidia.com/compute/cuda/13.1.1/local_installers/cuda-repo-ubuntu${UBUNTU_VERSION_NO_DOT}-13-1-local_13.1.1-590.48.01-1_amd64.deb
	sudo dpkg -i cuda-repo-ubuntu${UBUNTU_VERSION_NO_DOT}-13-1-local_13.1.1-590.48.01-1_amd64.deb
	
	print_step "Setting up CUDA keyring..."
	sudo cp /var/cuda-repo-ubuntu${UBUNTU_VERSION_NO_DOT}-13-1-local/cuda-*-keyring.gpg /usr/share/keyrings/
	
	print_step "Updating package lists and installing CUDA Toolkit 13.1..."
	sudo apt-get update
	sudo apt-get -y install cuda-toolkit-13-1
	
	print_step "Cleaning up downloaded packages..."
	sudo rm cuda-repo-ubuntu${UBUNTU_VERSION_NO_DOT}-13-1-local_13.1.1-590.48.01-1_amd64.deb
fi

echo ""
print_info "Next steps:"
echo -e "  ${YELLOW}1.${NC}  Restart your terminal or run: ${CYAN}source ~/.zshrc${NC}"
echo -e "  ${YELLOW}2.${NC}  Verify installation: ${CYAN}nvcc --version${NC}"
echo ""