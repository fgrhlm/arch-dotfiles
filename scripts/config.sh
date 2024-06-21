#!/bin/bash
set -e

readonly DIR_RARCH=$HOME/rarch/dotfiles
readonly DIR_CONFIG=$HOME/.config

# check xorg user
check_xorg_root () {
    XORG_USER=$(ps -o user= -C Xorg)
    [ "$XORG_USER" = "root" ] && echo "xorg is root :(" || echo "xorg is not root :)"
}

config () {
    # Copy pywal templates
    $DIR_RARCH/pywal/copy-templates.sh
    
    # Install
    ln -sfv $DIR_RARCH/bash/bashrc $HOME/.bashrc
    ln -sfv $DIR_RARCH/bash/bash_profile $HOME/.bash_profile
    ln -sfv $DIR_RARCH/nvim $DIR_CONFIG/nvim
    ln -sfv $DIR_RARCH/alacritty/alacritty.toml $DIR_CONFIG/alacritty.toml
    ln -sfv $DIR_RARCH/i3/config $DIR_CONFIG/i3/config
    ln -sfv $DIR_RARCH/picom/picom.conf $DIR_CONFIG/picom.conf
    ln -sfv $DIR_RARCH/polybar/config.ini $DIR_CONFIG/polybar/config.ini
    ln -sfv $DIR_RARCH/polybar/launch.sh $DIR_CONFIG/polybar/launch.sh
    ln -sfv $DIR_RARCH/tmux/tmux.conf $HOME/.tmux.conf
    ln -sfv $DIR_RARCH/gtk3/gtkrc $DIR_CONFIG/gtk-3.0/settings.ini
    ln -sfv $DIR_RARCH/btop/btop.conf $DIR_CONFIG/btop/btop.conf
    ln -sfv $DIR_RARCH/xorg/xinitrc $HOME/.xinitrc
    ln -sfv $DIR_RARCH/xorg/xserverrc $HOME/.xserverrc
    ln -sfv $DIR_RARCH/rofi/config.rasi $DIR_CONFIG/rofi/config.rasi
    
    sudo cp -v $DIR_RARCH/xorg/Xwrapper.config /etc/X11/Xwrapper.config
}

main () {
    config
    check_xorg_root
}

main
echo "done!"
