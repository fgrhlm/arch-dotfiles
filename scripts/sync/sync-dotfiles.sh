#!/bin/bash

set -e

link_dotfiles () {
    TMP_MANIFEST=".tmp_manifest"

    if [[ -f $TMP_MANIFEST ]]; then
        rm $TMP_MANIFEST
    fi

    envsubst < $HOME/rarch/dotfiles/manifest > $TMP_MANIFEST

    while read src dest_dir dest_file ;
    do
        if [[ ! -e $dest_dir ]]; then
            mkdir --parents --verbose $dest_dir
        fi

        ln --symbolic --force --verbose "${RARCH_DOTFILES}/${src}" "${dest_dir}/${dest_file}"
    done < $TMP_MANIFEST

    rm $TMP_MANIFEST
}
