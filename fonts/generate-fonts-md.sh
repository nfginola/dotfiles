#!/usr/bin/env bash
FONTS_DIR="$(cd "$(dirname "$0")/.local/share/fonts" && pwd)"
OUT="$(dirname "$0")/fonts.md"

echo "# Fonts" > "$OUT"
echo "" >> "$OUT"
echo "Font files are not tracked in git. Install them manually or via your package manager." >> "$OUT"
echo "" >> "$OUT"

declare -A groups
while IFS= read -r -d '' f; do
    name=$(basename "$f")
    # Group by family (strip variant suffix)
    family=$(echo "$name" | sed 's/-\(Bold\|Italic\|Regular\|BoldItalic\|Light\|Medium\|SemiBold\|ExtraBold\|Black\|Thin\).*$//')
    groups[$family]+="- \`$name\`"$'\n'
done < <(find "$FONTS_DIR" -type f \( -name "*.ttf" -o -name "*.otf" -o -name "*.woff2" \) -print0 | sort -z)

for family in $(echo "${!groups[@]}" | tr ' ' '\n' | sort); do
    echo "## $family" >> "$OUT"
    echo "" >> "$OUT"
    echo -e "${groups[$family]}" >> "$OUT"
done

echo "Generated $OUT"
