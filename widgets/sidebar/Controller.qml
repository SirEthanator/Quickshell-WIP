pragma Singleton

import Quickshell;
import QtQuick;

Singleton {
  property list<string> active;
  readonly property string current: active[active.length-1];
  readonly property bool sidebarOpen: active.length > 0;

  function activate(id: string) {
    active.push(id);
  }

  function deactivate(id: string) {
    const idx = active.indexOf(id);
    if (idx !== -1) {
      active.splice(active.indexOf(id), 1);
    }
  }

  function toggle(id: string) {
    const idx = active.indexOf(id);
    if (idx === -1) {
      active.push(id);
    } else {
      active.splice(active.indexOf(id), 1);
    }
  }

  readonly property var idIdxMap: ({
    "menu": 0,
    "polkit": 1
  })
}
