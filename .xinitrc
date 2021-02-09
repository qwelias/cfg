eval $(/usr/bin/gnome-keyring-daemon --start --components=pkcs11,secrets,ssh)
export SSH_AUTH_SOCK

xset s 300 5
xss-lock -n /usr/lib/xsecurelock/dimmer -l -- xsecurelock &

exec gnome-session
