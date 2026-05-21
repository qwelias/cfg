#!/usr/bin/env bash
set -o errexit
set -o errtrace
set -o pipefail
set -o nounset
shopt -s globstar
shopt -s nullglob
set -o xtrace

cap=$(cat /sys/class/power_supply/BAT0/capacity)
if ! grep 'Dis' /sys/class/power_supply/BAT0/status > /dev/null
then printf '\x06'
elif [[ $cap -lt 20 ]]
then printf '\x09'
elif [[ $cap -lt 30 ]]
then printf '\x02'
fi
printf ' '
printf '%02d' $cap
printf ' '