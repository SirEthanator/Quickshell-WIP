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

  property string currentPage: "global";
  property var changedProperties: ({});
  property int changeCount: 0;

  function changeVal(category, prop, value) {
    if (!changedProperties[category]) changedProperties[category] = {};
    changedProperties[category][prop] = value;

    if (value === Globals.conf[category][prop]) {
      delete changedProperties[category][prop];
      changeCount--;
    } else {
      changeCount++;
    }
  }

  function apply() {
    if (changedProperties.length !== 0) {
      for (const key in changedProperties) {
        for (const option in changedProperties[key]) {
          Globals.conf[key][option] = changedProperties[key][option];
        }
      }
      changedProperties = {};
      changeCount = 0;
    }
  }

  LazyLoader {
    id: loader;
    activeAsync: false;

    Window {
      id: window;
      color: Globals.colours.bg;

      minimumHeight: 200;
      minimumWidth: 800;

      visible: true;

      title: "Quickshell - Configuration";

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

