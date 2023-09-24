'use strict'

//    Window Title In Topbar
//    Puts the title of the focused window in the GNOME Shell top panel
//    Forked from https://extensions.gnome.org/extension/1496/focused-window-indicator/
//
//    ----------------------------------------------------------------------
//    Copyright © 2018  fthx
//    ----------------------------------------------------------------------
//
//    This program is free software: you can redistribute it and/or modify
//    it under the terms of the GNU General Public License as published by
//    the Free Software Foundation, either version 3 of the License, or
//    (at your option) any later version.
//
//    This program is distributed in the hope that it will be useful,
//    but WITHOUT ANY WARRANTY; without even the implied warranty of
//    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
//    GNU General Public License for more details.
//
//    You should have received a copy of the GNU General Public License
//    along with this program.  If not, see <https://www.gnu.org/licenses/>.
//
//    Refactored by qwelias@gmail.com

const St = imports.gi.St
const Clutter = imports.gi.Clutter
const Main = imports.ui.main
const Shell = imports.gi.Shell

let label
let focusWindowNotifyConnection = null
let windowTitleNotifyConnection = null
let focusedWindowIndicator
let window = null

function init() {
    focusedWindowIndicator = new St.Bin({ style_class: 'panel-button' })
    label = new St.Label({ y_align: Clutter.ActorAlign.CENTER })
    focusedWindowIndicator.set_child(label)
}

function enable() {
    Main.panel._leftBox.insert_child_at_index(focusedWindowIndicator, 3)

    focusWindowNotifyConnection = global.display.connect('notify::focus-window', on_focus_window_notify)
}

function disable() {
    global.display.disconnect(focusWindowNotifyConnection)
    disconnect_window()
    Main.panel._leftBox.remove_actor(focusedWindowIndicator)
}

const set_window_indicator = () => {
    if (!window) return

    let windowTitle = window.get_title()
    label.set_text(windowTitle)
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

