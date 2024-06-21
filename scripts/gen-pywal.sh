#!/bin/bash
set -e

main () {
    # Copy pywal templates
    $HOME/rarch/dotfiles/pywal/copy-templates.sh

    # Run pywal
    wal -i ~/Downloads/bg
}

main
