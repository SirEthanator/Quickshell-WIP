pragma ComponentBehavior: Bound

import "root:/";
import "root:/components";
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
        Sidebar { controller: root }
        Options { controller: root }
      }

      Dialog {
        id: changesDialog;
        title: "Save changes?";
        description: "You have unsaved changes, would you like to save them?";

        Button {
          label: "Discard";
          autoImplicitHeight: true;
          Layout.fillWidth: true;
          tlRadius: true; blRadius: true;
          bg: Globals.colours.bgLight;
          onClicked: root.quit();
        }
        Button {
          label: "Cancel";
          autoImplicitHeight: true;
          Layout.fillWidth: true;
          bg: Globals.colours.bgLight;
          onClicked: changesDialog.close();
        }
        Button {
          label: "Save";
          autoImplicitHeight: true;
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

