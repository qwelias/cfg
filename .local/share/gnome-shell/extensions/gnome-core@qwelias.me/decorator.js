import Gio from 'gi://Gio'

let listener = null

export const name = 'decorator'

export const enable = () => {
    listener = global.display.connect('window-created', (display, window) => {
        remove_decorator(window)
    })
}

export const disable = () => {
    global.display.disconnect(listener)
}

const remove_decorator = (window) => {
    try {
        Gio.Subprocess.new(
            ['xprop', '-id', window.get_description(), '-format', '_MOTIF_WM_HINTS', '32c', '-set', '_MOTIF_WM_HINTS', '2'],
            Gio.SubprocessFlags.NONE,
        );
    } catch (e) {
        console.error(e)
    }
}

