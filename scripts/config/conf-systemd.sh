#!/bin/bash

config_systemd_units () {
    echo_color "${BG_BLUE}${FG_GREY}" "[${FUNCNAME}].."
    sudo systemctl enable cpupower 
    sudo systemctl enable bluetooth.service 
    sudo systemctl enable NetworkManager 
    sudo systemctl enable firewalld
    echo_color "${BG_GREEN}${FG_GREY}" "[${FUNCNAME}] DONE!"
}
