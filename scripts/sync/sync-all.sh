#!/bin/bash
set -e

if [[ -z $XDG_CONFIG_HOME ]]; then
    echo "XDG_CONFIG_HOME not set, using default!"
    export XDG_CONFIG_HOME="${HOME}/.config"
fi

if [[ -z $RARCH_ROOT ]]; then
    echo "RARCH_ROOT not set, using default!"
    export RARCH_ROOT="${HOME}/rarch"
fi

if [[ -z $RARCH_DOTFILES ]]; then
    echo "RARCH_DOTFILES not set, using default!"
    export RARCH_DOTFILES="${RARCH_ROOT}/dotfiles"
fi

if [[ -z $RARCH_SCRIPTS ]]; then
    echo "RARCH_SCRIPTS not set, using default!"
    export RARCH_SCRIPTS="${RARCH_ROOT}/scripts"
fi

source $RARCH_SCRIPTS/common/colors.sh
source $RARCH_SCRIPTS/config/conf-cpupower.sh
source $RARCH_SCRIPTS/config/conf-ff.sh
source $RARCH_SCRIPTS/config/conf-gamemode.sh
source $RARCH_SCRIPTS/config/conf-perf.sh
source $RARCH_SCRIPTS/config/conf-systemd.sh
source $RARCH_SCRIPTS/config/conf-xorg.sh
source $RARCH_SCRIPTS/sync/sync-dotfiles.sh

main () {
    # Link dotfiles
    link_dotfiles
    
    # Snowflakes that require more intervention
    config_xorg
    config_cpupower
    config_gamemode
    config_systemd_units
    config_ff
    config_perf
}

main
