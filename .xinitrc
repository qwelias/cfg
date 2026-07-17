[[ -f ~/.Xresources ]] && xrdb -merge -I$HOME ~/.Xresources

nm-applet &
blueman-applet &
(
	while :
	do
		feh --bg-fill -z ~/Pictures/backgrounds
		sleep 600
	done
) &

xset s 300
xset dpms 0 0 600
xss-lock -l -- slock &
xcompmgr -n &

dbus-update-activation-environment --systemd DISPLAY XAUTHORITY XDG_CURRENT_DESKTOP DBUS_SESSION_BUS_ADDRESS
exec dwm 2> ~/.dwm.log