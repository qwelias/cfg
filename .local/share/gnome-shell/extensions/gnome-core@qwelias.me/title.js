import * as Main from 'resource:///org/gnome/shell/ui/main.js'
import St from 'gi://St'
import Clutter from 'gi://Clutter'

export const name = 'title'

let label = null
let focusWindowNotifyConnection = null
let windowTitleNotifyConnection = null
let focusedWindowIndicator
let window = null

export const enable = () => {
    focusedWindowIndicator = new St.Bin({ style_class: 'panel-button' })
    label = new St.Label({ y_align: Clutter.ActorAlign.CENTER })
    focusedWindowIndicator.set_child(label)

    Main.panel._leftBox.insert_child_at_index(focusedWindowIndicator, 3)

    focusWindowNotifyConnection = global.display.connect('notify::focus-window', on_focus_window_notify)

    on_focus_window_notify()
}

export const disable = () => {
    global.display.disconnect(focusWindowNotifyConnection)
    disconnect_window()
    Main.panel._leftBox.remove_child(focusedWindowIndicator)
}

const set_window_indicator = () => {
    if (!window) return
    label.set_text(window.get_title())
}

const disconnect_window = () => {
    if (windowTitleNotifyConnection && window) window.disconnect(windowTitleNotifyConnection)
}

const on_focus_window_notify = () => {
    disconnect_window()

    window = global.display.get_focus_window()
    if (!window) {
        label.set({ 'visible': false })
        return
    }

    label.set({ 'visible': true })
    windowTitleNotifyConnection = window.connect("notify::title", set_window_indicator)
    set_window_indicator()
}

