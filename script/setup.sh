#!/usr/bin/env bash

set -o errexit
set -o pipefail
set -o nounset
set -o xtrace

install_base () {
	sudo pacman -S git base-devel pacman-contrib
}
	
install_yay () {
	git clone https://aur.archlinux.org/yay.git
	cd yay
	makepkg -si
	cd ..
	rm -rf yay
	yay -Y --gendb
	yay -Syu --devel
	yay -Y --devel --save
}

install_goodies () {
	yay -S --needed \
		zsh \
		parallel neofetch bind tig nvm jq acpi htop inotify-tools \
		rustup lldb tfenv \
		xss-lock xsecurelock \
		xclip micro visual-studio-code-bin \
		ttf-ubuntu-font-family numix-square-icon-theme \
		seahorse \
		brave-bin \
		openvpn networkmanager-openvpn \
		mpc-qt vlc qbittorrent subtitleeditor \
		caddy kooha nnn nmap 
}

setup_zsh () {
	chsh -s $(which zsh)
	sudo chsh -s $(which zsh)
	sudo ln -s /usr/share/zsh/plugins/zsh-syntax-highlighting /usr/share/oh-my-zsh/plugins/zsh-syntax-highlighting
	sudo cp ~/.config/qwelias.zsh-theme /usr/share/oh-my-zsh/themes/qwelias.zsh-theme
	sudo cp ~/.zshrc /root/.zshrc
}

install_gnome () {
	yay -S --needed $(yay -Sgq gnome | grep -vf script/gnome-exclude) gnome-tweaks dconf-editor 
}

setup_gnome () {
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

setup_keyring () {
	sudo sh -c 'printf "\npassword    optional    pam_gnome_keyring.so" >> /etc/pam.d/passwd'
	sudo sh -c 'printf "\nauth       optional     pam_gnome_keyring.so\nsession    optional     pam_gnome_keyring.so auto_start" >> /etc/pam.d/login'
	echo '\e[35mAfter logging in next time set Login keyring as default manually using Seahorse'	
}

fns=('install_base' 'install_yay' 'install_goodies' 'setup_zsh' 'install_gnome' 'setup_gnome' 'setup_keyring')

if [ $# -eq 0 ]
then args=("${fns[@]}")
else args=("$@")
fi

for fn in "${args[@]}"
do $fn
done
