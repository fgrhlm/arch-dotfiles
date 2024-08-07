#!/bin/bash

link_dotfiles () {
    TMP_MANIFEST=".tmp_manifest"
    
    if [[ -f $TMP_MANIFEST ]]; then
        rm $TMP_MANIFEST
    fi

    envsubst < $HOME/rarch/dotfiles/manifest > $TMP_MANIFEST

    echo_color "${BG_BLUE}${FG_GREY}" "[${FUNCNAME}].."
     
    while read src dest_dir dest_file ;
    do
        if [[ ! -e $dest_dir ]]; then
            mkdir --parents --verbose $dest_dir
            echo_color $F_RESET "    ${dest_dir} does not exist.. creating.."
        fi
       
        ln --symbolic --force --verbose "${RARCH_DOTFILES}/${src}" "${dest_dir}/${dest_file}"
    done < $TMP_MANIFEST
    
    rm $TMP_MANIFEST
    echo_color "${BG_GREEN}${FG_GREY}" "[${FUNCNAME}] DONE!"
}
