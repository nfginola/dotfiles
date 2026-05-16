#!/usr/bin/env bash
DOTFILES="$(cd "$(dirname "$0")" && pwd)"

# Generate fonts list
bash "$DOTFILES/fonts/generate-fonts-md.sh"

# Generate installed packages list
OUT="$DOTFILES/packages.md"
echo "# Installed Packages" > "$OUT"
echo "" >> "$OUT"

echo "## Explicitly installed (pacman)" >> "$OUT"
echo "" >> "$OUT"
pacman -Qqe | grep -v "$(pacman -Qqm)" | while read -r pkg; do
    echo "- \`$pkg\`" >> "$OUT"
done

echo "" >> "$OUT"
echo "## AUR packages" >> "$OUT"
echo "" >> "$OUT"
pacman -Qqm | while read -r pkg; do
    echo "- \`$pkg\`" >> "$OUT"
done

echo "Generated $OUT"
