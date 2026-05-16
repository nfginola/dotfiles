#!/usr/bin/env bash
set -e
DOTFILES="$(cd "$(dirname "$0")" && pwd)"

backup_conflicts() {
    local pkg=$1
    stow --dir="$DOTFILES" --target="$HOME" --simulate "$pkg" 2>&1 \
        | grep "cannot stow" \
        | sed "s|.*over existing target \(.*\) since.*|\1|" \
        | while read -r f; do mv "$HOME/$f" "$HOME/$f.bak"; done
}

# Stow all packages (skip _prefixed dirs like _not_stowable)
for pkg in "$DOTFILES"/*/; do
    name=$(basename "$pkg")
    [[ "$name" == _* ]] && continue
    backup_conflicts "$name"
    stow --dir="$DOTFILES" --target="$HOME" "$name"
done

fc-cache -f

echo "Done. Run setup scripts manually - search for setup.sh"
