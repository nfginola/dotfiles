#!/bin/bash
# swaps Caps Lock and Escape on TTY login by hooking into PAM.
# pam_exec runs loadkeys as root at session open, before the shell starts.
#
# applies to TTY only
# keep a root TTY open when editing PAM config; a broken stack can lock you out.

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# loadkeys searches recursively under /usr/share/kbd/keymaps/
sudo mkdir -p /usr/share/kbd/keymaps
sudo cp "$SCRIPT_DIR/usr/share/kbd/keymaps/swap.map" /usr/share/kbd/keymaps/swap.map

PAM_LINE="session    optional   pam_exec.so quiet /usr/bin/loadkeys swap"
PAM_FILE="/etc/pam.d/system-login"

if grep -qF "pam_exec.so quiet /usr/bin/loadkeys swap" "$PAM_FILE"; then
    echo "Already present in $PAM_FILE, nothing to do."
else
    echo "$PAM_LINE" | sudo tee -a "$PAM_FILE" > /dev/null
    echo "Appended to $PAM_FILE."
fi

