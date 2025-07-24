#!/bin/bash

if [[ "${1}" = "on" ]]; then
    dunstify --replace=1338 "Nightlight ON!"
fi

if [[ "${1}" = "off" ]]; then
    dunstify --replace=1338 "Nightlight OFF!"
fi
