#!/bin/bash
set -e

main (){
    rm -fv $HOME/.lesshst
    rm -fv $HOME/.viminfo
    rm -fv $HOME/.local/share/recently-used.xbel
    rm -fv $HOME/.bash_history
    rm -fv $HOME/.bash_logout
    rm -fv $HOME/.bash_history-*.tmp
    rm -fv $HOME/.sqlite_history
    rm -fv $HOME/.python_history
    rm -fv $HOME/.wget-hsts
    rm -fv $HOME/Downloads/*
    rm -rfv $HOME/.nv
    rm -rfv $HOME/.cabal
    rm -rfv $HOME/.ipython
    rm -rfv $HOME/.jupyter
    rm -rfv $HOME/.local/share/Trash
    rm -rfv $HOME/.local/share/cache
    rm -rfv $HOME/.local/share/RecentDocuments
    rm -rfv $HOME/Public
    rm -rfv $HOME/.cache/*
    sudo pacman -Sc --noconfirm
    sudo rm -rfv /var/log/journal

    echo "done!"
}

main
