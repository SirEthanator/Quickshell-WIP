import "root:/";
import Quickshell;
import QtQuick;
import QtQuick.Layouts;

DashItem {
  Text {
    text: "pfp"
    color: Globals.colours.fg;
    font: Globals.vars.mainFont;
  }

  ColumnLayout {
    spacing: Globals.vars.marginCardSmall;
    Text {
      text: "username"
      color: Globals.colours.fg;
      font: Globals.vars.mainFont;
    }
    Text {
      text: "hostname"
      color: Globals.colours.fg;
      font: Globals.vars.mainFont;
    }
  }

  Text {
    Layout.alignment: Qt.AlignRight;
    text: "power icon"
    color: Globals.colours.fg;
    font: Globals.vars.mainFont;
  }
}

