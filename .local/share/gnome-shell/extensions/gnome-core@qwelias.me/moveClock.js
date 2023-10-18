import * as Main from 'resource:///org/gnome/shell/ui/main.js'

export const name = 'moveClock'

export const enable = () => {
    // do nothing if the clock isn't centred in this mode
    if (Main.sessionMode.panel.center.indexOf('dateMenu') == -1) {
        return
    }

    const centerBox = Main.panel._centerBox
    const rightBox = Main.panel._rightBox
    const dateMenu = Main.panel.statusArea['dateMenu']
    let children = centerBox.get_children()

    // only move the clock if it's in the centre box
    if (children.indexOf(dateMenu.container) != -1) {
        centerBox.remove_actor(dateMenu.container)

        children = rightBox.get_children()
        rightBox.insert_child_at_index(dateMenu.container, children.length - 1)
    }
}

export const disable = () => {
    // do nothing if the clock isn't centred in this mode
    if (Main.sessionMode.panel.center.indexOf('dateMenu') == -1) {
        return
    }

    const centerBox = Main.panel._centerBox
    const rightBox = Main.panel._rightBox
    const dateMenu = Main.panel.statusArea['dateMenu']
    const children = rightBox.get_children()

    // only move the clock back if it's in the right box
    if (children.indexOf(dateMenu.container) != -1) {
        rightBox.remove_actor(dateMenu.container)
        centerBox.add_actor(dateMenu.container)
    }
}
