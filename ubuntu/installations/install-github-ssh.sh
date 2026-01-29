#!/usr/bin/env bash
set -e

echo "======================================"
echo "  SETTING UP GITHUB SSH"
echo "======================================"

### GitHub SSH config
echo ">> Setting up GitHub SSH config..."

mkdir -p ~/.ssh
chmod 700 ~/.ssh

if [ ! -f ~/.ssh/personal ]; then
  echo ">> Generating SSH key: ~/.ssh/personal"
  ssh-keygen -t ed25519 -f ~/.ssh/personal -C "khoaah1411@gmail.com"
fi

SSH_CONFIG="$HOME/.ssh/config"
if ! grep -q "Host github.com" "$SSH_CONFIG" 2>/dev/null; then
  cat <<EOF >> "$SSH_CONFIG"

# personal account
Host github.com
    HostName github.com
    User khoanguyn1411
    IdentityFile ~/.ssh/personal
EOF
fi

chmod 600 ~/.ssh/config

echo "✅ GitHub SSH setup complete!"
echo ""
echo "📋 Your SSH public key:"
cat ~/.ssh/personal.pub
echo ""
