#!/bin/bash

config_ff () {
    sudo cp -v $RARCH_DOTFILES/firefox/autoconfig.js /usr/lib/firefox-developer-edition/defaults/pref/autoconfig.js
    sudo cp -v $RARCH_DOTFILES/firefox/config.js /usr/lib/firefox-developer-edition/firefox.cfg
    sudo cp -v $RARCH_DOTFILES/firefox/policies.json /usr/lib/firefox-developer-edition/distribution/policies.json
    sudo mkdir -pv /usr/lib/firefox-developer-edition/distribution/extensions
    sudo cp -v $RARCH_DOTFILES/firefox/default-search.xpi /usr/lib/firefox-developer-edition/distribution/extensions/default-search.xpi
    sudo rm -fv /usr/lib/firefox-developer-edition/browser/features/screenshots@mozilla.org.xpi
    sudo rm -fv /usr/lib/firefox-developer-edition/browser/features/formautofill@mozilla.org.xpi
    sudo rm -fv /usr/lib/firefox-developer-edition/browser/features/webcompat-reporter@mozilla.org.xpi
    sudo rm -fv /usr/lib/firefox-developer-edition/crashreporter
    sudo rm -fv /usr/lib/firefox-developer-edition/minidump-analyzer
    sudo rm -fv /usr/lib/firefox-developer-edition/pingsender
}
