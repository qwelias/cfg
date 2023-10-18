// https://gjs.guide/extensions/overview/imports-and-modules.html
import * as hideActivities from './hideActivities.js'
import * as moveClock from './moveClock.js'
import * as hideAccessibility from './hideAccessibility.js'
import * as theme from './theme.js'
import * as title from './title.js'
import * as decorator from './decorator.js'

const uuid = 'gnome-core@qwelias.me'

export default class GnomeCodeQwelias {
    enable() {
        console.log(`${uuid}:enable`)
        for (const sub of subs) doSub(sub, 'enable')
    }

    disable() {
        console.log(`${uuid}:disable`)
        for (const sub of subs) doSub(sub, 'disable')
    }
}

const subs = [
    // hideActivities,
    moveClock,
    hideAccessibility,
    theme,
    title,
    decorator,
]

/** @typedef {{ enable: () => void, disable: () => void, name: string }} Sub */

/**
 * @param {any}
 * @param {'enable' | 'disable'} action 
 */
const doSub = (sub, action) => {
    console.log(`${uuid}:doSub:${sub.name}:${action}`)
    try {
        sub[action]()
    } catch (e) {
        console.log(`${uuid}:doSub:${sub.name}:${action}:error ${e}`)
    }
}
