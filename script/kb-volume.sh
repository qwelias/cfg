#!/usr/bin/env bash
set -o errexit
set -o errtrace
set -o pipefail
# set -o nounset
shopt -s globstar
shopt -s nullglob
# set -o xtrace

getname() {
	grep -E 'device\.profile\.description|node\.description' | head -n1 | awk -F= '{print $2}' | tr -d '"' | xargs || echo '???'
}

if [ $1 = + ] || [ $1 = - ]
then 
	wpctl set-volume -l 1.5 @DEFAULT_AUDIO_SINK@ 5%$1

	vol=$(wpctl get-volume @DEFAULT_AUDIO_SINK@ | awk '{print $2" * 100 / 3 * 2"}' | bc)
	name=$(wpctl inspect @DEFAULT_AUDIO_SINK@ | getname)
	if test $1 = +
	then notify-send -u low -h INT:value:$vol -h STRING:x-dunst-stack-tag:volume '󰕾 +++++                  |' "$name"
	else notify-send -u low -h INT:value:$vol -h STRING:x-dunst-stack-tag:volume '󰕾 -----                  |' "$name"
	fi
elif [ $1 = x ]
then
	wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle

	name=$(wpctl inspect @DEFAULT_AUDIO_SINK@ | getname)
	if wpctl get-volume @DEFAULT_AUDIO_SINK@ | grep M
	then notify-send -u low -h STRING:x-dunst-stack-tag:volume '󰝟 XXXXX' "$name"
	else
		vol=$(wpctl get-volume @DEFAULT_AUDIO_SINK@ | awk '{print $2" * 100 / 3 * 2"}' | bc)
		notify-send -u low -h INT:value:$vol -h STRING:x-dunst-stack-tag:volume '󰕾 )))))                  |' "$name"
	fi
elif [ $1 = m ]
then
	wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle

	name=$(wpctl inspect @DEFAULT_AUDIO_SOURCE@ | getname)
	if wpctl get-volume @DEFAULT_AUDIO_SOURCE@ | grep M
	then notify-send -u low -h STRING:x-dunst-stack-tag:volume ' XXXXX' "$name"
	else notify-send -u low -h STRING:x-dunst-stack-tag:volume ' (((((' "$name"
	fi
fi