#!/usr/bin/env bash
set -o errexit
set -o errtrace
set -o pipefail
# set -o nounset
shopt -s globstar
shopt -s nullglob
# set -o xtrace

case "$BLOCK_BUTTON" in
	1) ~/script/kb-volume.sh m ;;
	3) ~/script/kb-volume.sh x ;;
	4) ~/script/kb-volume.sh + ;;
	5) ~/script/kb-volume.sh - ;;
esac

sink=$(wpctl get-volume @DEFAULT_AUDIO_SINK@)
sinkv=$(echo "$sink" | awk '{print $2" * 100 /1"}' | bc)
sinkm=$(echo "$sink" | awk '{print $3}')

# source=$(wpctl get-volume @DEFAULT_AUDIO_SOURCE@)
# sourcev=$(echo "$source" | awk '{print $2" * 100 /1"}' | bc)
sourcem=$(wpctl get-volume @DEFAULT_AUDIO_SOURCE@ | awk '{print $3}')

printf '  '
if [[ "$sourcem" == *M* ]]; then printf ' '
else printf ' '
fi

if [[ "$sinkm" == *M* ]]; then printf '󰝟 '
else printf '󰕾 '
fi
printf '%03d' $sinkv
printf '  '

# printf ' ~ '

# printf '%03d' $sourcev