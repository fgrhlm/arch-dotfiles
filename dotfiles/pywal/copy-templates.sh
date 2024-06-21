#!/bin/bash

set -e

main () {
    cp -v $HOME/rarch/dotfiles/pywal/template-alacritty.toml $HOME/.config/wal/templates/colors-rarch-alacritty.toml
    cp -v $HOME/rarch/dotfiles/pywal/template-polybar.ini $HOME/.config/wal/templates/colors-rarch-polybar.ini
}

main
