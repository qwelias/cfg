import GLib from 'gi://GLib'
import Gio from 'gi://Gio'
import St from 'gi://St'
import { Button } from 'resource:///org/gnome/shell/ui/panelMenu.js'
import { panel } from 'resource:///org/gnome/shell/ui/main.js'
import Clutter from 'gi://Clutter'

export const name = 'mon'

let timeout = null
let cpumem = null

export const enable = () => {
  disable()

  const label = new St.Label({ text: '...', y_align: Clutter.ActorAlign.CENTER })
  cpumem = new Button(0.0, 'qwemon', true)
  cpumem.add_child(label)
  panel.addToStatusArea('qwemon', cpumem)

  cpumem.connect('button-press-event', (widget, buttonNumber) => {
    update(label)

    return Clutter.EVENT_STOP
  })

  timeout = GLib.timeout_add_seconds(GLib.PRIORITY_DEFAULT_IDLE, 2, () => {
    update(label)
    return true
  })
}

export const disable = () => {
  if (cpumem) {
    cpumem.stop()
    cpumem.destroy()
    cpumem = null
  }

  if (timeout) {
    GLib.source_remove(timeout)
    timeout = null
  }
}

const update = (label) => {
  const status = []

  const cpu = readCpu()
  if (prevCpu) {
    const totalDelta = prevCpu.total - cpu.total
    const idleDelta = prevCpu.idle - cpu.idle

    status.push(Math.ceil((100 * (1 - idleDelta / totalDelta))))
  } else {
    status.push('')
  }
  prevCpu = cpu

  status.push(Math.ceil(readMem()))

  label.set_text(status.join(' ~ '))
}

let prevCpu = null
const readCpu = () => {
  const line = readFileLines('/proc/stat')
    .split("\n")[0]
    .trim()
    .split(/\s+/)
    .slice(1)
    .map(Number)

  const total = line.reduce((a, b) => a + b, 0)
  const idle = line[3] + line[4] // idle + iowait

  return { total, idle }
}

const readMem = () => {
  let total = 0
  let available = 0

  for (const line of readFileLines('/proc/meminfo').split('\n')) {
    if (line.startsWith('MemTotal:')) {
      total = Number(line.split(/\s+/)[1])
    } else if (line.startsWith('MemAvailable:')) {
      available = Number(line.split(/\s+/)[1])
    } else if (total && available) {
      break
    }
  }

  const used = total - available
  return 100 * used / total
}

const readFileLines = (path) => {
  try {
    const file = Gio.File.new_for_path(path)
    const [, content] = file.load_contents(null)
    const text_decoder = new TextDecoder('utf-8')
    const content_str = text_decoder.decode(content)
    return content_str
  } catch (e) {
    console.error(`PROCESSING ERROR IN FILE: ${path} \n ${e}`)
  }
}
