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
	print_info "Detected Ubuntu version: $UBUNTU_VERSION"
	
	print_step "Updating package lists..."
	sudo apt-get update
	sudo apt-get install -y wget gnupg lsb-release
	
	print_step "Installing CUDA repository key..."
	wget https://developer.download.nvidia.com/compute/cuda/repos/ubuntu$(lsb_release -rs | sed -e 's/\.//')/x86_64/cuda-keyring_1.1-1_all.deb
	sudo dpkg -i cuda-keyring_1.1-1_all.deb
	
	print_step "Updating package lists and installing CUDA Toolkit..."
	sudo apt-get update
	sudo apt-get -y install cuda
fi

# Create symlink if not already present (ensures /usr/local/cuda exists)
if [ ! -L /usr/local/cuda ] && [ -d /usr/local/cuda-* ]; then
	CUDA_VERSION=$(ls -d /usr/local/cuda-* 2>/dev/null | tail -1 | xargs basename)
	print_step "Creating symlink for CUDA: /usr/local/cuda -> /usr/local/$CUDA_VERSION"
	sudo ln -sf /usr/local/$CUDA_VERSION /usr/local/cuda
fi

echo ""
print_done "CUDA Toolkit installation complete!"
echo ""
# Check if /usr/local/cuda symlink is valid and print log
if [ -L /usr/local/cuda ]; then
    CUDA_LINK_TARGET=$(readlink -f /usr/local/cuda)
    if [ -d "$CUDA_LINK_TARGET" ]; then
        print_success "/usr/local/cuda symlink is valid. Points to: $CUDA_LINK_TARGET"
    else
        print_error "/usr/local/cuda symlink exists but target does not exist: $CUDA_LINK_TARGET"
    fi
    print_info "ls -l /usr/local/cuda: $(ls -l /usr/local/cuda)"
else
    print_error "/usr/local/cuda symlink does not exist. CUDA environment variables may not work."
    print_info "ls -l /usr/local | grep cuda: $(ls -l /usr/local | grep cuda)"
fi

echo ""
print_info "Next steps:"
echo -e "  ${YELLOW}1.${NC}  Restart your terminal or run: ${CYAN}source ~/.zshrc${NC}"
echo -e "  ${YELLOW}2.${NC}  Verify installation: ${CYAN}nvcc --version${NC}"
echo ""