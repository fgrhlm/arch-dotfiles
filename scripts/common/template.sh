#!/usr/bin/env bash

set -o errexit
set -o nounset
set -o pipefail

if [[ "${TRACE-0}" == "1" ]]; then set -o xtrace; fi

usage () {
    echo -e "Usage:\n"
    exit 0
}

main () {
    echo "hello world!"
}

main "$@"
