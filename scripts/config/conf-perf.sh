#!/bin/bash

config_perf () {
    echo_color "${BG_BLUE}${FG_GREY}" "[${FUNCNAME}].."
    sudo cp -v $RARCH_DOTFILES/tuning/limits.conf /etc/security/limits.conf
    sudo cp -v $RARCH_DOTFILES/tuning/timing.conf /etc/tmpfiles.d/timing.conf
    sudo cp -v $RARCH_DOTFILES/tuning/disable-watchdog.conf /etc/modprobe.d/disable-watchdog.conf
    echo_color "${BG_GREEN}${FG_GREY}" "[${FUNCNAME}] DONE!"
}
