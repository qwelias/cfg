# cfg

an incomplete guide to my arch setup

highly recommend having a look at [script](./script) dir

## installation

1. boot up arch live ISO
1. `archinstall`
1. choose `xorg` profile
1. choose `networkmanager micro git base-devel` in additional packages
1. choose `multilib` in additional repositories
1. may have to set locale to `en_GB` (something with dconf)
1. rest is up to you
1. complete installation, reboot
1. `rm -rf .*`
1. `git clone --separate-git-dir cfg https://github.com/qwelias/cfg .`
1. `./script/setup.sh`
  - gnome setup may fail if I haven't updated gnome-shell/gtk/libadwaita
    - see [gnome-patch](https://github.com/qwelias/gnome-patch) and it's usage in `setup.sh`
    - may have to skip some parts of it manually

## fonts
https://gist.github.com/YoEight/d19112db56cd8f93835bf2d009d617f7

## LUKS
- if you encrypt root partition with LUKS you may want to replace usage of `xss-lock` and `xsecurelock` with `go-luks-suspend-git`
- see `.xinitrc`

## GPU
nothing specific here, up to you, see arch wiki