#!/usr/bin/env sh

set -o errexit
set -o pipefail
set -o nounset
set -o xtrace

goodies () {
	yay -S --needed \
		pacman-contrib \
		parallel neofetch bind tig nvm jq acpi htop inotify-tools \
		rustup lldb tfenv \
		xss-lock xsecurelock \
		xclip micro-bin visual-studio-code-bin \
		ttf-ubuntu-font-family gnome-tweaks numix-square-icon-theme dconf-editor \
		seahorse \
		brave-bin \
		openvpn networkmanager-openvpn \
		mpc-qt vlc qbittorrent subtitleeditor \
		caddy kooha nnn nmap 
}

zsh () {
	sudo ln -s /usr/share/zsh/plugins/zsh-syntax-highlighting /usr/share/oh-my-zsh/plugins/zsh-syntax-highlighting
	sudo cp ~/.config/qwelias.zsh-theme /usr/share/oh-my-zsh/themes/qwelias.zsh-theme
	sudo cp ~/.zshrc /root/.zshrc
}

gnome () {
	yay -S --needed \
		autoconf \
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
}

keyring () {
	sudo sh -c 'printf "\npassword    optional    pam_gnome_keyring.so" >> /etc/pam.d/passwd'
	sudo sh -c 'printf "\nauth       optional     pam_gnome_keyring.so\nsession    optional     pam_gnome_keyring.so auto_start" >> /etc/pam.d/login'
	echo '\e[35mAfter logging in next time set Login keyring as default manually using Seahorse'	
}

fns=('goodies' 'zsh' 'keyring')

if [ $# -eq 0 ]
then args=("${fns[@]}")
else args=("$@")
fi

for fn in "${args[@]}"
do $fn
done
