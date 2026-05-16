#!/bin/bash

SESSIONS=$(tmux list-sessions -F "#{session_name}" 2>/dev/null)
CHOICE=$(printf "New Session\n%s" "$SESSIONS" | rofi -dmenu -p "tmux")

[ -z "$CHOICE" ] && exit 0

if [ "$CHOICE" = "New Session" ]; then
    wezterm start -- tmux new-session
else
    wezterm start -- tmux attach-session -t "$CHOICE"
fi
