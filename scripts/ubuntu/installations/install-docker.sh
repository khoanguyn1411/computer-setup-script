#!/usr/bin/env bash
set -e

# Load colors
SCRIPT_DIR="$(dirname "$(dirname "$(readlink -f "$0")")")" 
source "$SCRIPT_DIR/../shared/colors.sh"

print_header "INSTALLING DOCKER"

### Install Docker
print_step "Installing Docker dependencies..."
sudo DEBIAN_FRONTEND=noninteractive apt-get update > /dev/null 2>&1
sudo DEBIAN_FRONTEND=noninteractive apt-get install -y \
  ca-certificates curl gnupg lsb-release > /dev/null 2>&1
print_success "Dependencies installed"

print_step "Adding Docker GPG key..."
sudo mkdir -p /etc/apt/keyrings
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | \
  sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg 2>/dev/null
print_success "GPG key added"

print_step "Adding Docker repository..."
echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] \
  https://download.docker.com/linux/ubuntu \
  $(lsb_release -cs) stable" | \
  sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
print_success "Docker repository added"

print_step "Installing Docker Engine..."
sudo DEBIAN_FRONTEND=noninteractive apt-get update > /dev/null 2>&1
sudo DEBIAN_FRONTEND=noninteractive apt-get install -y \
  docker-ce docker-ce-cli containerd.io docker-compose-plugin > /dev/null 2>&1
print_success "Docker Engine installed"

print_step "Adding user to docker group..."
sudo usermod -aG docker "$USER"
print_success "User added to docker group"

print_done "Docker installation complete!"
print_warning "Log out and back in for docker group permissions to take effect"
