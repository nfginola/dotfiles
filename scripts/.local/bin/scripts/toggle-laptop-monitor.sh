#!/usr/bin/env bash
if xrandr | grep -q "^eDP-1 connected [0-9]"; then
    xrandr --output eDP-1 --off
else
    xrandr --output eDP-1 --auto --right-of DP-1-0
    xdotool mousemove --screen 0 1280 720
fi
~/.config/polybar/launch.sh
