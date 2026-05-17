#!/usr/bin/env bash
LAPTOP=$(xrandr | awk '/^[^ ]+ connected/ { cur=$1; found=0 } /^ / && cur && !found { if ($1=="1920x1080") print cur; found=1 }' | head -1)
EXTERNAL=$(xrandr | awk '/^[^ ]+ connected/ { cur=$1; found=0 } /^ / && cur && !found { if ($1=="2560x1440") print cur; found=1 }' | head -1)

if xrandr | grep -q "^$LAPTOP connected [0-9]"; then
    xrandr --output "$LAPTOP" --off
else
    xrandr --output "$LAPTOP" --auto --right-of "$EXTERNAL"
    xdotool mousemove --screen 0 1280 720
fi
~/.config/polybar/launch.sh
