#!/bin/bash

gpg --keyserver keys.openpgp.org --recv-keys "${1}" && \
gpg --export --armor "${1}" > "${1}.gpg" && \
gpg --batch --yes --delete-keys "${1}"

