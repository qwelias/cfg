#!/usr/bin/env bash
set -o errexit
set -o errtrace
set -o pipefail
# set -o nounset
shopt -s globstar
shopt -s nullglob
# set -o xtrace

if [ $1 = + ] || [ $1 = - ]
then 
	wpctl set-volume -l 1.5 @DEFAULT_AUDIO_SINK@ 5%$1

	vol=$(wpctl get-volume @DEFAULT_AUDIO_SINK@ | awk '{print $2" * 100 / 3 * 2"}' | bc)
	if test $1 = +
	then notify-send -u low -h INT:value:$vol -h STRING:x-dunst-stack-tag:volume '󰕾 +++++'
	else notify-send -u low -h INT:value:$vol -h STRING:x-dunst-stack-tag:volume '󰕾 -----'
	fi
elif [ $1 = x ]
then
	wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle

	if wpctl get-volume @DEFAULT_AUDIO_SINK@ | grep M
	then notify-send -u low -h STRING:x-dunst-stack-tag:volume '󰝟 XXXXX'
	else
		vol=$(wpctl get-volume @DEFAULT_AUDIO_SINK@ | awk '{print $2" * 100 / 3 * 2"}' | bc)
		notify-send -u low -h INT:value:$vol -h STRING:x-dunst-stack-tag:volume '󰕾 )))))'
	fi
elif [ $1 = m ]
then
	wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle

	if wpctl get-volume @DEFAULT_AUDIO_SOURCE@ | grep M
	then notify-send -u low -h STRING:x-dunst-stack-tag:volume ' XXXXX'
	else notify-send -u low -h STRING:x-dunst-stack-tag:volume ' ((((('
	fi
fi