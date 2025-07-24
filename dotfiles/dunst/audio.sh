#!/bin/bash

VOL=$(awk -F"[][]" '/Left:/ { print $2 }' <(amixer sget Master))
dunstify --replace=1337 "Volume:" "${VOL}"
play ~/rarch/ui.mp3
