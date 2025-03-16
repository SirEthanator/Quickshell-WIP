import "root:/";
import "root:/animations" as Anims;
import Quickshell.Io;
import QtQuick;
import QtQuick.Layouts;

MouseArea {
  id: root;
  required property int index;
  required property string text;
  property string command: "";
  hoverEnabled: true;

  signal selected();

  Layout.fillWidth: true;
  Layout.fillHeight: true;

  Process { id: cmd }
  function runCmd() {
    cmd.command = ["sh", "-c", command];
    cmd.startDetached();
    Globals.states.menuOpen = false;
  }

  onClicked: {
    selected();
    if (command !== "") {
      runCmd();
    }
  }

  Rectangle {
    id: background;
    anchors.fill: parent;
      color: root.containsPress
        ? Globals.colours.accent
        : root.containsMouse
          ? Globals.colours.bgHover
          : Globals.colours.bg;
      topLeftRadius: root.index === 0 || root.containsMouse ? Globals.vars.br : 0;
      topRightRadius: root.index === 1 || root.containsMouse ? Globals.vars.br : 0;
      bottomLeftRadius: root.index === 0 || root.containsMouse ? Globals.vars.br : 0;
      bottomRightRadius: root.index === 1 || root.containsMouse ? Globals.vars.br : 0;

      Anims.NumberTransition on topLeftRadius {}
      Anims.NumberTransition on topRightRadius {}
      Anims.NumberTransition on bottomLeftRadius {}
      Anims.NumberTransition on bottomRightRadius {}

      Anims.ColourTransition on color {}

      Text {
        anchors.centerIn: parent;
        text: root.text;
        color: root.containsPress ? Globals.colours.bg : Globals.colours.fg;
        font {
          family: Globals.vars.fontFamily;
          pixelSize: Globals.vars.mainFontSize;
        }
      }
  }
}

