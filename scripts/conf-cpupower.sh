#!/bin/bash

config_cpupower () {
    echo_color "${BG_BLUE}${FG_GREY}" "[${FUNCNAME}].."
    sudo cpupower frequency-set -g performance
    echo_color "${BG_GREEN}${FG_GREY}" "[${FUNCNAME}] DONE!"
}
