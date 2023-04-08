'use strict'

// https://gjs.guide/extensions/overview/imports-and-modules.html
const ExtensionUtils = imports.misc.extensionUtils
const Me = ExtensionUtils.getCurrentExtension()

const subs = [
    'hideActivities',
    'moveClock',
    'hideAccessibility',
    'theme',
    'title',
]

/**
 * @param {string} name 
 * @param {'enable' | 'disable' | 'init'} action 
 */
const doSub = (name, action) => {
    log(`${Me.metadata.uuid}:doSub:${name}:${action}`)
    try {
        Me.imports[name][action]()
    } catch (e) {
        log(`${Me.metadata.uuid}:doSub:${name}:${action}:error ${e}`)
    }
}

function init() {
    log(`${Me.metadata.uuid}:init`)
    for (const name of subs) doSub(name, 'init')
}

function enable() {
    log(`${Me.metadata.uuid}:enable`)
    for (const name of subs) doSub(name, 'enable')
}

function disable() {
    log(`${Me.metadata.uuid}:disable`)
    for (const name of subs) doSub(name, 'disable')
}
