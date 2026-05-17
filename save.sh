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
echo "| Package | Version |" >> "$OUT"
echo "| ------- | ------- |" >> "$OUT"
comm -23 <(pacman -Qqe | sort) <(pacman -Qqm | sort) | xargs expac -Q '%n %v' | while read -r pkg ver; do
    echo "| \`$pkg\` | $ver |" >> "$OUT"
done

echo "" >> "$OUT"
echo "## AUR packages" >> "$OUT"
echo "" >> "$OUT"
echo "| Package | Version |" >> "$OUT"
echo "| ------- | ------- |" >> "$OUT"
pacman -Qqm | xargs expac -Q '%n %v' | while read -r pkg ver; do
    echo "| \`$pkg\` | $ver |" >> "$OUT"
done

pacman_pkgs=$(comm -23 <(pacman -Qqe | sort) <(pacman -Qqm | sort) | tr '\n' ' ')
aur_pkgs=$(pacman -Qqm | grep -v '^yay' | tr '\n' ' ')
echo "" >> "$OUT"
echo "## Reinstall" >> "$OUT"
echo "" >> "$OUT"
echo "\`\`\`" >> "$OUT"
echo "sudo pacman -S $pacman_pkgs" >> "$OUT"
echo "" >> "$OUT"
echo "yay -S $aur_pkgs" >> "$OUT"
echo "\`\`\`" >> "$OUT"
echo "" >> "$OUT"
echo "### Bootstrapping yay" >> "$OUT"
echo "" >> "$OUT"
echo "\`\`\`bash" >> "$OUT"
echo "git clone https://aur.archlinux.org/yay.git" >> "$OUT"
echo "cd yay && makepkg -si" >> "$OUT"
echo "\`\`\`" >> "$OUT"

echo "Generated $OUT"
