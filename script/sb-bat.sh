#!/usr/bin/env bash
set -o errexit
set -o errtrace
set -o pipefail
# set -o nounset
shopt -s globstar
shopt -s nullglob
# set -o xtrace

setpower() {
	powerprofilesctl set $1 && notify $1
}

notify() {
	notify-send -h STRING:x-dunst-stack-tag:power -u low "󱐋 $1"
}

case "$BLOCK_BUTTON" in
	1) setpower balanced ;;
	2) setpower performance ;;
	3) setpower power-saver ;;
	4) notify "max life" ;;
	5) notify "max charge" ;;
esac

cap=$(cat /sys/class/power_supply/BAT0/capacity)
if grep 'Charg' /sys/class/power_supply/BAT0/status > /dev/null
then printf '\x06'
elif [ $cap -le 10 ]
then printf '\x09' && notify-send -t 2000 -u critical "󱃍 $cap% charge left !!!"
elif [ $cap -lt 20 ]
then printf '\x09'
elif [ $cap -lt 30 ]
then printf '\x02'
elif grep 'Disch' /sys/class/power_supply/BAT0/status > /dev/null
then printf '\x08'
fi

prof=$(cat /sys/devices/system/cpu/cpu0/cpufreq/energy_performance_preference)
profs='.'
if [[ $prof = b* ]]
then profs='·'
elif [[ $prof = pe* ]]
then profs=':'
fi

printf ' '
printf '%02d' $cap
printf $profs