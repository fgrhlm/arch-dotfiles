#!/bin/bash
set -e

main (){
    # Files
    rm -f $HOME/.lesshst
    rm -f $HOME/.viminfo
    rm -f $HOME/.local/share/recently-used.xbel
    rm -f $HOME/.bash_history
    rm -f $HOME/.bash_history-*.tmp
    rm -f $HOME/.sqlite_history
    rm -f $HOME/.python_history
    rm -f $HOME/.wget-hsts
    rm -f $HOME/Downloads/*

    # Folders
    rm -rf $HOME/.nv
    rm -rf $HOME/.mozilla
    rm -rf $HOME/.local/share/Trash
    rm -rf $HOME/.local/share/cache
    rm -rf $HOME/.local/share/RecentDocuments
    rm -rf $HOME/Public
    rm -rf $HOME/.cache/*

    # Clear pacman cache
    sudo pacman -Sc --noconfirm

    # Nuke logs
    sudo rm -rf /var/log/journal
    for CLEAN in $(find /var/log/ -type f)
    do
        cp /dev/null $CLEAN
    done
    
    echo "done!"
}

main
