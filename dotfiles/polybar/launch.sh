#!/bin/bash

polybar-msg cmd quit

echo "---" | tee -a /tmp/polybar1.log
MONITOR=DP-2 polybar -r main 2>&1 | tee -a /tmp/polybar1.log & disown
MONITOR=HDMI-0 polybar -r second 2>&1 | tee -a /tmp/polybar1.log & disown
