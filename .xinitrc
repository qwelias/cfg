xset s 300 5
xss-lock -n /usr/lib/xsecurelock/dimmer -l -- xsecurelock &

devilspie2 &

(
	sleep 5
	ps aux | grep -v grep | grep terminal || pkill -9 gnome-session
) &

exec gnome-session
