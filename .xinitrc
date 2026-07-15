# eval $(/usr/bin/gnome-keyring-daemon --start --components=pkcs11,secrets,ssh)
# export SSH_AUTH_SOCK

# xset s 300 5
# xss-lock -n /usr/lib/xsecurelock/dimmer -l -- xsecurelock &
# xset 600
# xss-lock xlock +resetsaver &
# 
# devilspie2 &
# 
# exec gnome-session
# 
# if [ -d /etc/X11/xinit/xinitrc.d ] ; then
#     for f in /etc/X11/xinit/xinitrc.d/?*.sh ; do
#         [ -x "$f" ] && . "$f"
#     done
#     unset f
# fi

[[ -f ~/.Xresources ]] && xrdb -merge -I$HOME ~/.Xresources

xcompmgr -n &
nm-applet &
blueman-applet &
feh --bg-fill ~/Pictures/background.jpeg &

xset s 300
xset dpms 0 0 600
xss-lock -l -- slock &

dbus-update-activation-environment --systemd DISPLAY XAUTHORITY XDG_CURRENT_DESKTOP DBUS_SESSION_BUS_ADDRESS
#exec /home/me/my/de/dwm/dwm 2> ~/.dwm.log
exec dwm 2> ~/.dwm.log