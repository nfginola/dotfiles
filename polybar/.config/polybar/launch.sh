#!/usr/bin/env bash
killall -q polybar
while pgrep -u $UID -x polybar > /dev/null; do sleep 0.1; done

if xrandr | grep -q "DP-1-0 connected"; then
    MONITOR=DP-1-0 polybar main &
fi
MONITOR=eDP-1 polybar main &
