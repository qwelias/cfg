'use strict'

const Main = imports.ui.main;

function init() {}

function enable () {
    Main.setThemeStylesheet('/usr/share/themes/qwelias/gnome-shell/gnome-shell.css')
    Main.loadTheme()
}

function disable () {
    Main.setThemeStylesheet('/usr/share/gnome-shell/theme/default.css') // can be whatever
    Main.loadTheme()
}