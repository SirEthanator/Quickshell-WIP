pragma ComponentBehavior: Bound

import "root:/";
import Quickshell;
import Quickshell.Io;
import QtQuick;
import QtQuick.Layouts;

Scope {
  id: root;
  IpcHandler {
    target: "confMenu";
    function open(): void { loader.activeAsync = true }
    function close(): void { loader.activeAsync = false }
  }

  property Config currentPage: Globals.conf["global"];

  LazyLoader {
    id: loader;
    activeAsync: false;

    FloatingWindow {
      id: window;
      color: Globals.colours.bg;
      minimumSize: Qt.size(50, 50);  // TEMP

      onVisibleChanged: {
        if (!visible) loader.activeAsync = false;
      }

      RowLayout {
        anchors.fill: parent;
        Sidebar { controller: root }
        Options { controller: root }
      }
    }
  }
}

