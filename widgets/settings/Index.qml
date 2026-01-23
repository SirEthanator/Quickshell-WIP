pragma ComponentBehavior: Bound

import qs.singletons
import qs.components
import qs.widgets.settings // For LSP
import Quickshell;
import Quickshell.Io;
import QtQuick;
import QtQuick.Layouts;

Scope {
  id: root;

  IpcHandler {
    target: "settings";
    function open(): void { loader.activeAsync = true }
    function close(): void { loader.activeAsync = false }
  }

  Connections {
    target: Globals;
    function onLaunchConfMenu() { loader.activeAsync = true }
  }

  function quit() {
    Controller.resetChanges();
    loader.activeAsync = false;
  }

  // TODO: Improve scaling to allow smaller widths

  LazyLoader {
    id: loader;
    activeAsync: false;

    Window {
      id: window;
      color: Globals.colours.bg;

      minimumWidth: 750;
      minimumHeight: 200;

      visible: true;

      title: "Quickshell - Settings";

      onClosing: e => {
        if (Controller.changeCount > 0) {
          e.accepted = false;
          changesDialog.open();
        } else {
          root.quit();
        }
      }

      RowLayout {
        anchors.fill: parent;
        spacing: 0;
        Sidebar {}
        Options {}
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
            Controller.apply();
            root.quit();
          }
        }
      }
    }
  }
}

