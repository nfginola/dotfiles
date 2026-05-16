#!/usr/bin/env bash
set -e
TPM_DIR="$HOME/.tmux/plugins/tpm"
if [[ ! -d "$TPM_DIR" ]]; then
    git clone --depth=1 https://github.com/tmux-plugins/tpm "$TPM_DIR"
    echo "tpm cloned — open tmux and press prefix + I to install plugins"
else
    echo "tpm already present"
fi
