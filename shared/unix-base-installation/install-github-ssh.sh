#!/usr/bin/env bash
set -e

# This script should be sourced after colors.sh is loaded
# Shared GitHub SSH setup for both Ubuntu and macOS

print_header "SETTING UP GITHUB SSH"

print_step "Setting up GitHub SSH config..."

mkdir -p ~/.ssh
chmod 700 ~/.ssh

if [ ! -f ~/.ssh/personal ]; then
  print_step "Generating SSH key: ~/.ssh/personal"
  ssh-keygen -t ed25519 -f ~/.ssh/personal -C "khoaah1411@gmail.com" -N ""
  print_success "SSH key generated"
else
  print_info "SSH key already exists"
fi

SSH_CONFIG="$HOME/.ssh/config"
if ! grep -q "Host github.com" "$SSH_CONFIG" 2>/dev/null; then
  print_step "Configuring SSH for GitHub..."
  cat <<EOF >> "$SSH_CONFIG"

# personal account
Host github.com
    HostName github.com
    User khoanguyn1411
    IdentityFile ~/.ssh/personal

# example custom host account
# Host github.com-saritasa
#     HostName github.com
#     User khoanguyen-saritasa
#     IdentityFile ~/.ssh/saritasa

EOF
  print_success "SSH config updated"
else
  print_info "GitHub SSH config already exists"
fi

chmod 600 ~/.ssh/config

print_done "GitHub SSH setup complete!"
echo ""
print_info "Your SSH public key:"
echo -e "${CYAN}"
cat ~/.ssh/personal.pub
echo -e "${NC}"
print_warning "Copy this key to GitHub: https://github.com/settings/keys"