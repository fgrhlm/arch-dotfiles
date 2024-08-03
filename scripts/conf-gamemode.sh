#!/bin/bash

config_gamemode () {
    echo_color "${BG_BLUE}${FG_GREY}" "[${FUNCNAME}].."
    sudo usermod -aG gamemode $USER
    echo_color "${BG_GREEN}${FG_GREY}" "[${FUNCNAME}] DONE!"
}
