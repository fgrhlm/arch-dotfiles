#!/bin/bash

config_ff () {
    echo_color "${BG_BLUE}${FG_GREY}" "[${FUNCNAME}].."
    sudo cp -v $RARCH_DOTFILES/firefox/autoconfig.js /usr/lib/firefox/defaults/pref/autoconfig.js
    sudo cp -v $RARCH_DOTFILES/firefox/config.js /usr/lib/firefox/defaults/pref/firefox.cfg
    sudo cp -v $RARCH_DOTFILES/firefox/policies.json /usr/lib/firefox/distribution/policies.json
    sudo rm -fv /usr/lib/firefox/browser/features/screenshots@mozilla.org.xpi
    sudo rm -fv /usr/lib/firefox/browser/features/formautofill@mozilla.org.xpi
    sudo rm -fv /usr/lib/firefox/browser/features/webcompat-reporter@mozilla.org.xpi
    sudo rm -fv /usr/lib/firefox/crashreporter
    sudo rm -fv /usr/lib/firefox/minidump-analyzer
    sudo rm -fv /usr/lib/firefox/pingsender
    echo_color "${BG_GREEN}${FG_GREY}" "[${FUNCNAME}] DONE!"
}
