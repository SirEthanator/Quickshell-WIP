pragma ComponentBehavior: Bound

import qs
import qs.components
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

  Connections {
    target: Globals;
    function onLaunchConfMenu() { loader.activeAsync = true }
  }

  property string currentPage: "global";
  property var changedProperties: ({});
  property int changeCount: 0;

  function getVal(category, prop) {
    if (typeof changedProperties[category] !== "undefined" && typeof changedProperties[category][prop] !== "undefined") {
      return changedProperties[category][prop]
    } else {
      return Globals.conf[category][prop]
    }
  }

  function changeVal(category: string, prop: string, value: var): void {
    if (!changedProperties[category]) changedProperties[category] = {};
    changedProperties[category][prop] = value;

    if (value.toString() === Globals.conf[category][prop].toString()) {
      delete changedProperties[category][prop];
    }
    changeCount = getChangeCount();
  }

  function getChangeCount() {
    let result = 0;
    for (const key in changedProperties) {
      for (const _ in changedProperties[key]) { result++ }
    }
    return result;
  }

  function apply() {
    if (changedProperties.length !== 0) {
      for (const key in changedProperties) {
        for (const option in changedProperties[key]) {
          const newValue = changedProperties[key][option];
          const callback = Globals.conf[key].getMetadata(option).callback;

          Globals.conf[key][option] = newValue;

          if (typeof callback === "function") {
            callback(newValue)
          }
        }
      }
      changedProperties = {};
      changeCount = 0;
    }
  }

  function quit() {
    changedProperties = {};
    changeCount = 0;
    loader.activeAsync = false;
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
        if (root.changeCount > 0) {
          e.accepted = false;
          changesDialog.open();
        } else {
          root.quit();
        }
      }

      RowLayout {
        anchors.fill: parent;
        spacing: 0;
        Sidebar { controller: root }
        Options { controller: root }
      }

      Dialog {
        id: changesDialog;
        title: "Save changes?";
        description: "You have unsaved changes, would you like to save them?";

        Button {
          label: "Discard";
          Layout.fillWidth: true;
          tlRadius: true; blRadius: true;
          bg: Globals.colours.bgLight;
          onClicked: root.quit();
        }
        Button {
          label: "Cancel";
          Layout.fillWidth: true;
          bg: Globals.colours.bgLight;
          onClicked: changesDialog.close();
        }
        Button {
          label: "Save";
          Layout.fillWidth: true;
          trRadius: true; brRadius: true;
          bg: Globals.colours.bgLight;
          onClicked: {
            root.apply();
            root.quit();
          }
        }
      }
    }
  }
}

