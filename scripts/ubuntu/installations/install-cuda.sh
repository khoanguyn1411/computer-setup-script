#!/bin/bash
# install-cuda.sh: Installs NVIDIA CUDA Toolkit on Ubuntu or WSL
# Usage: sudo ./install-cuda.sh

set -e

# Load colors for pretty printing
SCRIPT_DIR="$(dirname "$(readlink -f "$0")")"
source "$SCRIPT_DIR/../../../shared/colors.sh"

print_header "NVIDIA CUDA TOOLKIT INSTALLATION"

# Check if we should skip CUDA installation in local mode without GPU
if [ "$SETUP_ENV" != "ci" ]; then
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

# Detect if running in WSL
if grep -qiE "microsoft|wsl" /proc/version; then
	print_info "Detected WSL environment. Using WSL-specific CUDA installation."
	print_step "Updating package lists..."
	sudo apt-get update
	sudo apt-get install -y wget gnupg lsb-release jq
	
	print_step "Setting up CUDA repository pin..."
	wget https://developer.download.nvidia.com/compute/cuda/repos/wsl-ubuntu/x86_64/cuda-wsl-ubuntu.pin
	sudo mv cuda-wsl-ubuntu.pin /etc/apt/preferences.d/cuda-repository-pin-600

	print_step "Fetching latest CUDA Toolkit version for WSL..."
	LATEST_TOOLKIT=$(wget -qO- https://developer.download.nvidia.com/compute/cuda/repos/wsl-ubuntu/x86_64/ | grep -oP 'cuda-toolkit-\d+-\d+_\d+\.\d+\.\d+-1_amd64.deb' | sort -V | tail -n1)
	if [ -z "$LATEST_TOOLKIT" ]; then
		print_error "Could not determine latest CUDA Toolkit version. Exiting."
		exit 1
	fi
	print_info "Latest CUDA Toolkit package: $LATEST_TOOLKIT"
	TOOLKIT_VERSION=$(echo "$LATEST_TOOLKIT" | grep -oP '(?<=cuda-toolkit-)\d+-\d+')
	print_info "Installing cuda-toolkit-$TOOLKIT_VERSION"

	print_step "Updating package lists and installing CUDA Toolkit..."
	sudo apt-get update
	sudo apt-get -y install cuda-toolkit-$TOOLKIT_VERSION
else
	print_info "Detected native Ubuntu environment. Using standard CUDA installation."
	UBUNTU_VERSION=$(lsb_release -sr)
	UBUNTU_VERSION_NO_DOT=$(echo "$UBUNTU_VERSION" | sed -e 's/\.//')
	print_info "Detected Ubuntu version: $UBUNTU_VERSION"
	
	print_step "Updating package lists..."
	sudo apt-get update
	sudo apt-get install -y wget gnupg lsb-release jq
	
	print_step "Fetching latest CUDA repository package for Ubuntu $UBUNTU_VERSION..."
	LATEST_CUDA_REPO=$(wget -qO- https://developer.download.nvidia.com/compute/cuda/repos/ubuntu${UBUNTU_VERSION_NO_DOT}/x86_64/ | grep -oP 'cuda-repo-ubuntu'${UBUNTU_VERSION_NO_DOT}'-\d+-\d+-local_[\d\.]+-[\d\.]+_amd64\.deb' | sort -V | tail -n1)
	if [ -z "$LATEST_CUDA_REPO" ]; then
		print_error "Could not determine latest CUDA repository package. Exiting."
		exit 1
	fi
	print_info "Latest CUDA repository package: $LATEST_CUDA_REPO"
	
	# Extract CUDA version from package name (e.g., 13-1 from cuda-repo-ubuntu2204-13-1-local_...)
	CUDA_VERSION=$(echo "$LATEST_CUDA_REPO" | grep -oP '(?<=ubuntu'${UBUNTU_VERSION_NO_DOT}'-)\d+-\d+')
	print_info "Detected CUDA version: $CUDA_VERSION"
	
	print_step "Setting up CUDA repository pin..."
	wget https://developer.download.nvidia.com/compute/cuda/repos/ubuntu${UBUNTU_VERSION_NO_DOT}/x86_64/cuda-ubuntu${UBUNTU_VERSION_NO_DOT}.pin
	sudo mv cuda-ubuntu${UBUNTU_VERSION_NO_DOT}.pin /etc/apt/preferences.d/cuda-repository-pin-600
	
	print_step "Downloading and installing CUDA repository deb package..."
	wget https://developer.download.nvidia.com/compute/cuda/repos/ubuntu${UBUNTU_VERSION_NO_DOT}/x86_64/$LATEST_CUDA_REPO
	sudo dpkg -i $LATEST_CUDA_REPO
	
	print_step "Setting up CUDA keyring..."
	sudo cp /var/cuda-repo-ubuntu${UBUNTU_VERSION_NO_DOT}-${CUDA_VERSION}-local/cuda-*-keyring.gpg /usr/share/keyrings/
	
	print_step "Updating package lists and installing CUDA Toolkit..."
	sudo apt-get update
	sudo apt-get -y install cuda-toolkit-${CUDA_VERSION}
fi

echo ""
print_info "Next steps:"
echo -e "  ${YELLOW}1.${NC}  Restart your terminal or run: ${CYAN}source ~/.zshrc${NC}"
echo -e "  ${YELLOW}2.${NC}  Verify installation: ${CYAN}nvcc --version${NC}"
echo ""