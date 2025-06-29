import "root:/";
import "root:/components";
import "root:/animations" as Anims;
import Quickshell.Io;
import QtQuick;
import QtQuick.Layouts;

Button {
  required label;
  required property int index;
  property string command: "";
  signal selected;

  Layout.fillWidth: true;
  Layout.fillHeight: true;

  tlRadius: index === 0;
  trRadius: index === 1;
  blRadius: index === 0;
  brRadius: index === 1;

  Process { id: cmd }
  function runCmd() {
    cmd.command = ["sh", "-c", command];
    cmd.startDetached();
    Globals.states.menuOpen = false;
  }

  onClicked: {
    selected();
    if (command !== "") runCmd();
  }
}

