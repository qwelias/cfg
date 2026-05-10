#!/usr/bin/env bash
set -o errexit
set -o errtrace
set -o pipefail
set -o nounset
shopt -s globstar
shopt -s nullglob
set -o xtrace

rrr=/home/me/.local/share/proton-pfx/0
STEAM_COMPAT_DATA_PATH="$rrr" WINEPREFIX="$rrr/pfx" gamemoderun proton-ge run "$1"