#!/bin/bash
set -e

source $HOME/rarch/scripts/common/colors.sh

readonly DIR_RARCH=$HOME/rarch/dotfiles
readonly DIR_CONFIG=$HOME/.config

echo_color () {
    echo -e "${F_BOLD}${1}${2}${F_RESET}"
}

lnk () {
    if [[ ! -e $2 ]]; then
        mkdir --parents --verbose $dir
        echo_color $FG_AQUA "${2} was created!"
    fi
    
    echo_color $FG_AQUA "Linking ${1} -> ${2}/${3}"
    ln --symbolic --force --verbose "${DIR_RARCH}/${1}" "${2}/${3}"
}

config_cpupower () {
    echo_color "${BG_BLUE}${FG_GREY}" "Cpupower.."
    sudo cpupower frequency-set -g performance
}

config_gamemode () {
    echo_color "${BG_BLUE}${FG_GREY}" "Gamemode.."
    sudo usermod -aG gamemode $USER
}

config_xorg () {
    echo_color "${BG_BLUE}${FG_GREY}" "Generating xorg config.."
    sudo nvidia-xconfig -v
    sudo cp -v $DIR_RARCH/xorg/Xwrapper.config /etc/X11/Xwrapper.config
    echo_color "${BG_BLUE}${FG_GREY}" "Checking xorg privileges.."
    [ $(ps -o user= -C Xorg) = "root" ] && echo_color $FG_RED "XORG IS ROOT!!" || echo_color $FG_GREEN "Xorg privs OK"
}

config_systemd_units () {
    echo_color "${BG_BLUE}${FG_GREY}" "Enabling systemd units"
    sudo systemctl enable cpupower 
    sudo systemctl enable bluetooth.service 
    sudo systemctl enable NetworkManager 
    sudo systemctl enable firewalld
}

install_dotfiles () {
    echo_color "${BG_BLUE}${FG_GREY}" "Linking dotfiles.."
    
    # Install
    lnk /bash/bashrc $HOME .bashrc
    lnk /bash/bash_profile $HOME .bash_profile
    lnk /nvim $DIR_CONFIG nvim
    lnk /alacritty/alacritty.toml $DIR_CONFIG alacritty.toml
    lnk /i3/config $DIR_CONFIG/i3 config
    lnk /picom/picom.conf $DIR_CONFIG picom.conf
    lnk /polybar/config.ini $DIR_CONFIG/polybar config.ini
    lnk /polybar/mocha.ini $DIR_CONFIG/polybar mocha.ini
    lnk /polybar/launch.sh $DIR_CONFIG/polybar launch.sh
    lnk /tmux/tmux.conf $HOME/ .tmux.conf
    lnk /gtk3/gtkrc $DIR_CONFIG/gtk-3.0 settings.ini
    lnk /btop/btop.conf $DIR_CONFIG/btop btop.conf
    lnk /xorg/xinitrc $HOME .xinitrc
    lnk /xorg/xserverrc $HOME .xserverrc
    lnk /rofi/config.rasi $DIR_CONFIG/rofi config.rasi
    lnk /gamemode/gamemode.ini $DIR_CONFIG gamemode.ini
    lnk /firefox/policies.json $HOME/.mozilla/firefox policies.json    
    lnk /dri/drirc $DIR_CONFIG .drirc
}

apply_tunings () {
    echo_color "${BG_BLUE}${FG_GREY}" "Applying tunings.."
    sudo cp -v $DIR_RARCH/tuning/limits.conf /etc/security/limits.conf
    sudo cp -v $DIR_RARCH/tuning/timing.conf /etc/tmpfiles.d/timing.conf
    sudo cp -v $DIR_RARCH/tuning/disable-watchdog.conf /etc/modprobe.d/disable-watchdog.conf
}

main () {
    install_dotfiles
    config_xorg
    config_cpupower
    config_gamemode
    config_systemd_units
    apply_tunings
    
    echo_color "${BG_GREEN}${FG_GREY}" "Config done! Exiting!"
}

main
