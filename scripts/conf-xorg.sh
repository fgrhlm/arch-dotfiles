#!/bin/bash

config_xorg () {
    echo_color "${BG_BLUE}${FG_GREY}" "[${FUNCNAME}].."
    sudo cp -v $RARCH_DOTFILES/xorg/Xwrapper.config /etc/X11/Xwrapper.config
    sudo cp -v $RARCH_DOTFILES/xorg/xorg.conf /etc/X11/xorg.conf
    echo_color "${BG_BLUE}${FG_GREY}" "Checking xorg privileges.."
    [ $(ps -o user= -C Xorg) = "root" ] && echo_color $FG_RED "XORG IS ROOT!!" || echo_color $FG_GREEN "Xorg privs OK"
    echo_color "${BG_GREEN}${FG_GREY}" "[${FUNCNAME}] DONE!"
}
