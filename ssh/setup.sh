#!/usr/bin/env bash
set -e

ssh-keygen -t ed25519 -C "nfginola@gmail.com" -f ~/.ssh/github_personal

cat > ~/.ssh/config << 'EOF'
Host github.com
    IdentityFile ~/.ssh/github_personal
    AddKeysToAgent yes
EOF
chmod 600 ~/.ssh/config

echo ""
echo "Add this public key to GitHub (Settings → SSH and GPG keys → New SSH key):"
echo ""
cat ~/.ssh/github_personal.pub
echo ""
echo "Then test with: ssh -T git@github.com"
