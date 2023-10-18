import * as Main from 'resource:///org/gnome/shell/ui/main.js';

let monitorsChangedEvent = null

export const name = 'hideAccessibility'

export const enable = () => {
    monitorsChangedEvent = Main.layoutManager.connect('monitors-changed', hideIndicator)
    hideIndicator()
}

export const disable = () => {
    Main.layoutManager.disconnect(monitorsChangedEvent)
    const indicator = Main.panel.statusArea['a11y']
    indicator && indicator.show()
}

const hideIndicator = () => {
    const indicator = Main.panel.statusArea['a11y']
    indicator && indicator.hide()
}