#!/bin/bash

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

PAM_LINE="session    optional   pam_exec.so quiet /usr/bin/loadkeys swap"
PAM_FILE="/etc/pam.d/system-login"

if grep -qF "pam_exec.so quiet /usr/bin/loadkeys swap" "$PAM_FILE"; then
    echo "Already present in $PAM_FILE, nothing to do."
else
    echo "$PAM_LINE" | sudo tee -a "$PAM_FILE" > /dev/null
    echo "Appended to $PAM_FILE."
fi

sudo cp "$SCRIPT_DIR/vconsole.conf" /etc/vconsole.conf
echo "Copied vconsole.conf to /etc/vconsole.conf."
