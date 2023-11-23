#!/usr/bin/env bash
set -o errexit
set -o errtrace
set -o pipefail
set -o nounset
shopt -s globstar
shopt -s nullglob
# set -o xtrace

current=$(pactl info | grep 'Default Sink:' | awk '{print $3}')
sink=$(pactl list short sinks | grep -v "$current" | grep -E 'SUSPENDED|IDLE' | awk '{print $2}' | head -n1)
pactl set-default-sink $sink
sleep 0.2
paplay /usr/share/sounds/gnome/default/alerts/click.ogg