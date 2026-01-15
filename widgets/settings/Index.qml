pragma ComponentBehavior: Bound

import qs.singletons
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

  function getVal(category: string, opt: string): var {
    if (
      typeof changedProperties[category] !== "undefined" &&
      typeof changedProperties[category][opt] !== "undefined"
    ) {
      return changedProperties[category][opt]
    } else {
      return Conf[category][opt]
    }
  }

  function changeVal(category: string, prop: string, value: var): void {
    if (!changedProperties[category]) changedProperties[category] = {};
    changedProperties[category][prop] = value;

    if (value.toString() === Conf[category][prop].toString()) {
      delete changedProperties[category][prop];
    }
    changeCount = getChangeCount();
  }

  function getChangeCount() {
    let result = 0;
    for (const c in changedProperties) {
      for (const _ in changedProperties[c]) { result++ }
    }
    return result;
  }

  function apply() {
    if (changedProperties.length !== 0) {
      for (const category in changedProperties) {
        for (const option in changedProperties[category]) {
          const newValue = changedProperties[category][option];
          const callback = Conf.getMetadata(category, option)?.callback;

          Conf[category][option] = newValue;

          if (typeof callback === "function") {
            callback(newValue, getVal)
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

      minimumWidth: 800;
      minimumHeight: 200;

      visible: true;

      title: "Quickshell - Settings";

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

