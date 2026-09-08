if pgrep xdotool
then kill $(pgrep xdotool)
else sleep 1; xdotool click --repeat 1000 --delay 10 1
fi