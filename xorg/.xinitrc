#!/bin/bash

# NVIDIA + MangoHUD tweaks
#export __NV_PRIME_RENDER_OFFLOAD=1
#export __GLX_VENDOR_LIBRARY_NAME=nvidia
export MANGOHUD=1
export MANGOHUD_CONFIG="fps_limit=144,frametime,gpu_power,temperature"

# Respect external screen?
export SDL_VIDEO_FULLSCREEN_DISPLAY=1

export XCURSOR_THEME=Capitaine-Cursors
export XCURSOR_SIZE=64

nvidia-settings -a "[gpu:0]/GpuPowerMizerMode=1" &

# Start i3
# exec i3
# Enable session message bus
# Session bus is otherwise not automatically started
exec dbus-run-session i3

