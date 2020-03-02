#!/usr/bin/env sh

set -o errexit
set -o pipefail
set -o nounset
set -o xtrace

yay -S \
	xss-lock \
	xsecurelock \
	ttf-ubuntu-font-family \
	gnome-tweaks \
	numix-square-icon-theme \
	micro-bin \
	visual-studio-code-bin \
	google-chrome \
	chrome-gnome-shell \
	seahorse \
	tig \
	pacman-contrib

sudo ln -s /usr/share/zsh/plugins/zsh-syntax-highlighting /usr/share/oh-my-zsh/plugins/zsh-syntax-highlighting

sudo sh -c 'printf "\npassword    optional    pam_gnome_keyring.so" >> /etc/pam.d/passwd'
sudo sh -c 'printf "\nauth       optional     pam_gnome_keyring.so\nsession    optional     pam_gnome_keyring.so auto_start" >> /etc/pam.d/login'

sudo sh -c 'curl https://gist.githubusercontent.com/qwelias/e165b3f78c5ad6d8a61b093e0ef98d6b/raw > /usr/share/oh-my-zsh/themes/qwelias.zsh-theme'

sudo cp ~/.zshrc /root/.zshrc

yay -S autoconf \
	automake \
	inkscape \
	gdk-pixbuf2 \
	glib2 \
	libxml2 \
	pkgconf \
	sassc \
	parallel
	
git clone https://github.com/qwelias/adapta-gtk-theme /tmp/adapta
cd /tmp/adapta
./my-autogen.sh
make
sudo make install

echo '\e[35mAfter logging in next time set Login keyring as default manually using Seahorse'