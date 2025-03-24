#!/bin/bash

inotifywait -e close_write,moved_to,create -m "${1}" |
while read -r directory events filename; do
  if [ "$filename" = "${2}" ]; then
    echo "${directory} -> ${events} -> ${filename}"
    eval "${3}"
  fi
done
