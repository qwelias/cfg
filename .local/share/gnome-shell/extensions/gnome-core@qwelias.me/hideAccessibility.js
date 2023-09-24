'use strict'

const Main = imports.ui.main
let monitorsChangedEvent = null

const hideIndicator = () => {
    const indicator = Main.panel.statusArea['a11y']
    indicator && indicator.hide()
}

function enable() {
    monitorsChangedEvent = Main.layoutManager.connect('monitors-changed', hideIndicator)
    hideIndicator()
}

function disable() {
    Main.layoutManager.disconnect(monitorsChangedEvent)
    const indicator = Main.panel.statusArea['a11y']
    indicator && indicator.show()
}

function init () {}