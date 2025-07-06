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

    Window {
      id: window;
      color: Globals.colours.bg;

      minimumHeight: 200;
      minimumWidth: 800;

      visible: true;

      title: "Quickshell - Configuration"

      onClosing: e => {
        e.accepted = false;
        loader.activeAsync = false;
      }

      RowLayout {
        anchors.fill: parent;
        Sidebar { controller: root }
        Options { controller: root }
      }
    }
  }
}

