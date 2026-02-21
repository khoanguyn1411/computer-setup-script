#!/bin/bash
# install-audio.sh: Installs audio utilities on WSL
# Usage: sudo ./install-audio.sh

set -e

# Set non-interactive mode for apt
export DEBIAN_FRONTEND=noninteractive

# Load colors for pretty printing
SCRIPT_DIR="$(dirname "$(readlink -f "$0")")"
source "$SCRIPT_DIR/../../../shared/colors.sh"
source "$SCRIPT_DIR/../../../shared/utils.sh"

print_header "AUDIO UTILITIES INSTALLATION"

# Check if running in WSL
if is_wsl; then
	print_info "Detected WSL environment. Installing audio utilities..."
	
	print_step "Updating package lists..."
	sudo apt-get update -y
	
	print_step "Installing PulseAudio utilities..."
	sudo apt install -y pulseaudio-utils
	
	echo ""
	print_done "Audio utilities installation complete!"
	echo ""
	
	# Verify installation
	if command -v pactl &> /dev/null; then
		print_success "PulseAudio utilities installed successfully"
	else
		print_error "PulseAudio utilities installation failed"
		exit 1
	fi
else
	print_warning "Not running in WSL. Skipping audio utilities installation."
	print_info "Audio utilities are WSL-specific and not needed for native Ubuntu."
	exit 0
fi

echo ""
print_info "Audio utilities are now available for WSL audio support"
echo ""
