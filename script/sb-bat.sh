#!/usr/bin/env bash
set -o errexit
set -o errtrace
set -o pipefail
set -o nounset
shopt -s globstar
shopt -s nullglob
# set -o xtrace

printf ' '
printf '%02d' "$(cat /sys/class/power_supply/BAT0/capacity)"
printf ' '