pragma Singleton

import Quickshell;
import QtQuick;

Singleton {
  readonly property list<string> active: internal.active;
  readonly property string finalActive: internal.finalActive;
  readonly property string current: active[active.length-1];
  readonly property bool sidebarOpen: active.length > 0;

  QtObject {
    id: internal;

    property list<string> active;
    property string finalActive;
  }

  onCurrentChanged: {
    if (!!current) {
      internal.finalActive = current;
    }
  }

  function activate(id: string) {
    internal.active.push(id);
  }

  function deactivate(id: string) {
    const idx = internal.active.indexOf(id);
    if (idx !== -1) {
      internal.active.splice(active.indexOf(id), 1);
    }
  }

  function toggle(id: string) {
    const idx = internal.active.indexOf(id);
    if (idx === -1) {
      internal.active.push(id);
    } else {
      internal.active.splice(active.indexOf(id), 1);
    }
  }

  readonly property var idIdxMap: ({
    "menu": 0,
    "polkit": 1
  })
}
