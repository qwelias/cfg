xset s 300 5
xss-lock -n /usr/lib/xsecurelock/dimmer -l -- xsecurelock &

(
	sleep 10
	ps aux | grep -v grep | grep ghostty || pkill -9 gnome-session
) &

exec gnome-session
