import * as Main from 'resource:///org/gnome/shell/ui/main.js'

export const name = 'theme'

export const enable = () => {
    Main.setThemeStylesheet('/usr/share/themes/qwelias/gnome-shell/gnome-shell.css')
    Main.loadTheme()
}

export const disable = () => {
    Main.setThemeStylesheet('/usr/share/gnome-shell/theme/default.css') // can be whatever
    Main.loadTheme()
}