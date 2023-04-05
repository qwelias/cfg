#!/usr/bin/env sh

set -o errexit
set -o pipefail
set -o nounset
set -o xtrace

rate-mirrors --protocol https arch | sudo tee /etc/pacman.d/mirrorlist