pragma Singleton

import qs.widgets.bar as Bar;
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

  onSidebarOpenChanged: {
    // Close bar tooltips & menus when the sidebar is opened
    if (sidebarOpen) {
      Bar.TooltipController.clearTooltip();
    }
  }

  onCurrentChanged: {
    if (!!current) {
      internal.finalActive = current;
    }
  }

  function activate(id: string) {
    internal.active.push(id);
    activated(id);
  }

  function deactivate(id: string) {
    const idx = internal.active.indexOf(id);
    if (idx !== -1) {
      internal.active.splice(active.indexOf(id), 1);
      deactivated(id);
    }
  }

  function deactivateAll() {
    internal.active = [];
  }

  function toggle(id: string) {
    if (internal.active.includes(id)) {
      deactivate(id);
    } else {
      activate(id);
    }
  }

  readonly property var idIdxMap: ({
    "menu": 0,
    "polkit": 1,
    "notifications": 2,
    "clipboard": 3
  })

  signal deactivated(id: string);
  signal activated(id: string);
}
