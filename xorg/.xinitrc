#!/bin/bash

# NVIDIA PRIME offload: uncomment to run specific apps on the dGPU via PRIME render offload.
# Not needed here — all rendering is already offloaded to NVIDIA via xrandr setprovideroutputsource below.
#export __NV_PRIME_RENDER_OFFLOAD=1
#export __GLX_VENDOR_LIBRARY_NAME=nvidia
export MANGOHUD=1
export MANGOHUD_CONFIG="fps_limit=144,frametime,gpu_power,temperature"

# SDL fullscreen targets display index 1 (second/external monitor) instead of the primary
export SDL_VIDEO_FULLSCREEN_DISPLAY=1

export XCURSOR_THEME=Capitaine-Cursors
export XCURSOR_SIZE=64

# GpuPowerMizerMode=1: prefer maximum performance (vs. 0=adaptive, 2=max battery)
nvidia-settings -a "[gpu:0]/GpuPowerMizerMode=1" &

# PRIME output: eDP/HDMI are AMD-wired (NVIDIA frames copied through it); DP is NVIDIA-direct (no copy).
# Skipped in integrated (NVIDIA off, no provider) and hybrid (AMD drives display; NVIDIA for per-app offload).
if envycontrol --query 2>/dev/null | grep -q "^nvidia$"; then
    # Pick the first non-NVIDIA provider (the AMD iGPU modesetting sink)
    SINK=$(xrandr --listproviders | awk -F'name:' '/name:/ && !/NVIDIA/ {print $2; exit}')
    # --setprovideroutputsource <provider> <source>: routes NVIDIA rendered frames through AMD for eDP/HDMI;
    # without this, NVIDIA output won't be forwarded to the iGPU
    xrandr --setprovideroutputsource NVIDIA "$SINK"
    xrandr --auto
fi

# Wraps i3 so apps (notifications, portals, tray) have a D-Bus session to connect to
# i.e. Thunar (file manager) and dunst (notifications) need session-wide D-Bus session to communicate
exec dbus-run-session i3

