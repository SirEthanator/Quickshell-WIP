import qs.singletons
import qs.components
import Quickshell;
import QtQuick;
import QtQuick.Layouts;

Button {
  required label;
  required property int index;
  property string command;
  property var action;
  signal selected;

  Layout.fillWidth: true;
  Layout.fillHeight: true;

  tlRadius: index === 0;
  trRadius: index === 1;
  blRadius: index === 0;
  brRadius: index === 1;

  function runCmd() {
    if (typeof action === "function") {
      action();
    }
    if (!!command) {
      Quickshell.execDetached(["sh", "-c", command]);
    }
    Globals.states.menuOpen = false;
  }

  onClicked: {
    selected();
    if (!!command || typeof action === "function") runCmd();
  }
}

