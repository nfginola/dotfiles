#!/bin/bash

# Keyboard layout: us/se/no toggled with win+space, swap caps<->lctrl
setxkbmap -layout us,se,no -option grp:win_space_toggle,ctrl:swapcaps

# Key repeat: 250ms delay, 70 chars/sec
xset r rate 250 70

# Touchpad tweaks
TOUCHPAD=$(xinput list --name-only 2>/dev/null | grep -i touchpad | head -1)
if [ -n "$TOUCHPAD" ]; then
    xinput set-prop "$TOUCHPAD" "libinput Natural Scrolling Enabled" 1 2>/dev/null
    xinput set-prop "$TOUCHPAD" "libinput Tapping Enabled" 1 2>/dev/null
fi

# Mouse: disable acceleration (flat profile)
MOUSE=$(xinput list --name-only 2>/dev/null | grep -i mouse | head -1)
if [ -n "$MOUSE" ]; then
    xinput set-prop "$MOUSE" "libinput Accel Profile Enabled" 0, 1 2>/dev/null
fi
