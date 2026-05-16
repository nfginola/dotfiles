#!/usr/bin/env bash
EXTERNAL="DP-1-0"
LAPTOP="eDP-1"

if xrandr | grep -q "^$EXTERNAL connected"; then
    xrandr --output $EXTERNAL --mode 2560x1440 --rate 143.97 --primary --output $LAPTOP --off
else
    xrandr --output $LAPTOP --mode 1920x1080 --rate 300 --primary
fi
