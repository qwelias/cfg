#!/usr/bin/env bash
set -o errexit
set -o errtrace
set -o pipefail
set -o nounset
shopt -s globstar
shopt -s nullglob
set -o xtrace

install_base () {
    sudo pacman -S git devtools base-devel pacman-contrib man
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
        docker docker-buildx docker-compose \
        zsh rate-mirrors \
        parallel fastfetch bind tig nvm jq acpi htop inotify-tools \
        rustup lldb \
        ghostty micro tldr \
        ttf-ubuntu-font-family ttf-dejavu \
        openvpn networkmanager-openvpn \
        nnn nmap
}

setup_zsh () {
    yay -S --needed zsh-syntax-highlighting
    chsh -s $(which zsh)
    sudo chsh -s $(which zsh)
    sudo cp ~/.zshrc /root/.zshrc
    sudo cp ~/.config/zsh-prompt.sh /root/.config
}

install_ui_things () {
    yay -S --needed xclip vscodium-bin \
    	seahorse brave-bin \
    	mpv vlc qbittorrent subtitleeditor
	sudo ln -s /usr/bin/codium /usr/bin/code
}

install_gnome () {
    yay -S --needed gnome gnome-browser-connector
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
        parallel \
        meson gobject-introspection vala

    git clone https://github.com/qwelias/gnome-patch /tmp/gnome-patch
    cd /tmp/gnome-patch
    ./patch.sh

    curl -L https://extensions.gnome.org/extension-data/trayIconsReloadedselfmade.pl.v29.shell-extension.zip > tray.zip
    gnome-extensions install tray.zip
    gsettings set org.gnome.shell disable-user-extensions true
    gsettings set org.gnome.shell disable-user-extensions false
    gsettings set org.gnome.desktop.interface enable-animations false
    gsettings set org.gnome.desktop.peripherals.mouse accel-profile flat
    gsettings set org.gnome.desktop.interface color-scheme prefer-dark
    gsettings set org.gnome.desktop.interface enable-hot-corners false
    gsettings set org.gnome.desktop.sound allow-volume-above-100-percent true
    gsettings set org.gnome.desktop.interface document-font-name 'Ubuntu 13'
    gsettings set org.gnome.desktop.interface font-antialiasing 'rgba'
    gsettings set org.gnome.desktop.interface font-hinting 'slight'
    gsettings set org.gnome.desktop.interface font-name 'Ubuntu Light 13'
    gsettings set org.gnome.desktop.interface monospace-font-name 'Ubuntu Mono 12'
    gsettings set org.gnome.desktop.input-sources per-window true
    gsettings set org.gnome.desktop.interface enable-hot-corners false
    gsettings set org.gnome.desktop.wm.keybindings switch-windows "['<Alt>Tab']"
    gsettings set org.gnome.desktop.wm.keybindings switch-windows-backward "['<Shift><Alt>Tab']"
    gsettings set org.gnome.desktop.wm.keybindings switch-input-source "['<Alt>space']"
    gsettings set org.gnome.desktop.wm.keybindings switch-input-source-backward "['<Shift><Alt>space']"
}

setup_keyring () {
    sudo sh -c 'printf "\npassword    optional    pam_gnome_keyring.so" >> /etc/pam.d/passwd'
    sudo sh -c 'printf "\nauth       optional     pam_gnome_keyring.so\nsession    optional     pam_gnome_keyring.so auto_start" >> /etc/pam.d/login'
    echo '\e[35mAfter logging in next time set Login keyring as default manually using Seahorse'    
}

desktop () {
	install_base
	install_yay
	install_goodies
	setup_zsh
	install_gnome
	install_ui_things
	setup_gnome
	setup_keyring
}

server () {
	install_base
	install_yay
	install_goodies
	setup_zsh
}

"${1:?missing first arg}"