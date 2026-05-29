if [ $1 = 'l' ]
then
	echo 60 | tee /sys/class/power_supply/BAT0/charge_control_start_threshold
	echo 80 | tee /sys/class/power_supply/BAT0/charge_control_end_threshold
elif [ $1 = 'h' ]
then
	echo 100 | tee /sys/class/power_supply/BAT0/charge_control_end_threshold
	echo 95 | tee /sys/class/power_supply/BAT0/charge_control_start_threshold
fi
