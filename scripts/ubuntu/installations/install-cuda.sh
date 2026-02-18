#!/bin/bash
# install-cuda.sh: Installs NVIDIA CUDA Toolkit on Ubuntu or WSL
# Usage: sudo ./install-cuda.sh

set -e

# Check for NVIDIA GPU
echo "[CUDA Installer] Checking for NVIDIA GPU..."
if command -v lspci &> /dev/null; then
	if lspci | grep -i nvidia &> /dev/null; then
		echo "[CUDA Installer] NVIDIA GPU detected."
	else
		echo "[CUDA Installer] No NVIDIA GPU detected. CUDA installation may not be useful."
	fi
else
	echo "[CUDA Installer] lspci not found. Skipping GPU check."
fi

echo "[CUDA Installer] Starting CUDA Toolkit installation..."

# Detect if running in WSL
if grep -qiE "microsoft|wsl" /proc/version; then
	echo "[CUDA Installer] Detected WSL environment. Using WSL-specific CUDA installation."
	sudo apt-get update
	sudo apt-get install -y wget gnupg lsb-release jq
	# Download the pin file
	wget https://developer.download.nvidia.com/compute/cuda/repos/wsl-ubuntu/x86_64/cuda-wsl-ubuntu.pin
	sudo mv cuda-wsl-ubuntu.pin /etc/apt/preferences.d/cuda-repository-pin-600

	# Dynamically find the latest CUDA Toolkit version for WSL
	echo "[CUDA Installer] Fetching latest CUDA Toolkit version for WSL..."
	LATEST_TOOLKIT=$(wget -qO- https://developer.download.nvidia.com/compute/cuda/repos/wsl-ubuntu/x86_64/ | grep -oP 'cuda-toolkit-\d+-\d+_\d+\.\d+\.\d+-1_amd64.deb' | sort -V | tail -n1)
	if [ -z "$LATEST_TOOLKIT" ]; then
		echo "[CUDA Installer] Could not determine latest CUDA Toolkit version. Exiting."
		exit 1
	fi
	echo "[CUDA Installer] Latest CUDA Toolkit package: $LATEST_TOOLKIT"
	# Extract version for apt install
	TOOLKIT_VERSION=$(echo "$LATEST_TOOLKIT" | grep -oP '(?<=cuda-toolkit-)\d+-\d+')
	echo "[CUDA Installer] Will install cuda-toolkit-$TOOLKIT_VERSION"

	# Download and install the repository .deb (not needed for toolkit, only for repo setup)
	# Download and install the keyring if not present
	# (skip local installer, use repo method)
	sudo apt-get update
	sudo apt-get -y install cuda-toolkit-$TOOLKIT_VERSION
else
	echo "[CUDA Installer] Detected native Ubuntu environment. Using standard CUDA installation."
	UBUNTU_VERSION=$(lsb_release -sr)
	echo "[CUDA Installer] Detected Ubuntu version: $UBUNTU_VERSION"
	sudo apt-get update
	sudo apt-get install -y wget gnupg lsb-release
	wget https://developer.download.nvidia.com/compute/cuda/repos/ubuntu$(lsb_release -rs | sed -e 's/\.//')/x86_64/cuda-keyring_1.1-1_all.deb
	sudo dpkg -i cuda-keyring_1.1-1_all.deb
	sudo apt-get update
	sudo apt-get -y install cuda
fi

# Add CUDA to PATH and LD_LIBRARY_PATH (for current user)
CUDA_PATH_LINE='export PATH=/usr/local/cuda/bin:$PATH'
CUDA_LD_LINE='export LD_LIBRARY_PATH=/usr/local/cuda/lib64:$LD_LIBRARY_PATH'
if ! grep -Fxq "$CUDA_PATH_LINE" ~/.bashrc; then
	echo "$CUDA_PATH_LINE" >> ~/.bashrc
fi
if ! grep -Fxq "$CUDA_LD_LINE" ~/.bashrc; then
	echo "$CUDA_LD_LINE" >> ~/.bashrc
fi

echo "[CUDA Installer] CUDA Toolkit installation complete. Please reboot or log out and back in for environment changes to take effect."
echo "[CUDA Installer] To verify installation, run: nvcc --version"
