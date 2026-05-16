#!/usr/bin/env bash
DOTFILES="$(cd "$(dirname "$0")" && pwd)"

human() {
    local b=$1
    if   (( b >= 1073741824 )); then awk "BEGIN {printf \"%.1f GB\", $b/1073741824}"
    elif (( b >= 1048576 ));    then awk "BEGIN {printf \"%.1f MB\", $b/1048576}"
    elif (( b >= 1024 ));       then awk "BEGIN {printf \"%.1f KB\", $b/1024}"
    else echo "${b} B"
    fi
}

# all files on disk, ignoring .git internals
full=$(fd --no-ignore --hidden --type f . "$DOTFILES" --exclude ".git" \
    | xargs stat -c%s | awk '{s+=$1} END {print s+0}')

# files that would be pushed to git (respects .gitignore)
lean=$(fd --type f . "$DOTFILES" \
    | xargs stat -c%s | awk '{s+=$1} END {print s+0}')

echo "Dotfiles size report"
echo "--------------------"
printf "Full  (all files):        %s\n" "$(human "$full")"
printf "Lean  (git-tracked only): %s\n" "$(human "$lean")"
