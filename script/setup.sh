#!/usr/bin/env sh

set -o errexit
set -o pipefail
set -o nounset
set -o xtrace

echo
echo 'Installing goodies'
yay -S ttf-ubuntu-font-family xss-lock xsecurelock micro-bin numix-square-icon-theme google-chrome

echo 'Setting GNOME Keyring unlock via PAM'
sudo sh -c 'printf "\npassword    optional    pam_gnome_keyring.so" >> /etc/pam.d/passwd'
sudo sh -c 'printf "\nauth       optional     pam_gnome_keyring.so\nsession    optional     pam_gnome_keyring.so auto_start" >> /etc/pam.d/login'

echo
echo 'Getting ZSH theme'
sudo sh -c 'curl https://gist.githubusercontent.com/qwelias/e165b3f78c5ad6d8a61b093e0ef98d6b/raw > /usr/share/oh-my-zsh/themes/qwelias.zsh-theme'

echo
echo 'Installing GNOME Shell theme'
yay -S autoconf automake inkscape gdk-pixbuf2 glib2 libxml2 pkgconf sassc parallel
git clone https://github.com/qwelias/adapta-gtk-theme /tmp/adapta

cd /tmp/adapta
./my-autogen.sh
make
sudo make install