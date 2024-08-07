#!/bin/bash
set -e

# Set environment
export vblank_mode=0
export VKD3D_CONFIG=force_static_cbv,nodxr
export __GL_THREADED_OPTIMIZATIONS=1
export __GL_MaxFramesAllowed=1
export __GL_SHADER_DISK_CACHE_SKIP_CLEANUP=1

main () {
    # Kill compositor
    killall picom

    # Set PCI-E latency timers
    sudo setpci -v -s '*:*' latency_timer=20
    sudo setpci -v -s '0:0' latency_timer=0
    sudo setpci -v -d "*:*:04xx" latency_timer=80
}

main
