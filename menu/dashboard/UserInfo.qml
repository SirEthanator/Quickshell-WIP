import "root:/";
import "root:/utils" as Utils;
import Quickshell.Io;
import QtQuick;
import QtQuick.Layouts;
import QtQuick.Effects;

DashItem {
  fullContentWidth: true;

  Image {
    id: pfp;
    source: "root:/pfp.png";
    sourceSize.width: 90;
    sourceSize.height: 90;
    visible: false;
  }

  MultiEffect {
    source: pfp;
    anchors.fill: pfp;
    maskEnabled: true;
    maskSource: circleMask;
    layer.smooth: true;
    maskThresholdMin: 0.5;
    maskSpreadAtMin: 1;
  }

  Item {
    id: circleMask;
    width: pfp.width;
    height: pfp.height;
    layer.enabled: true;
    visible: false;

    Rectangle {
      width: parent.width;
      height: parent.height;
      radius: width/2
    }
  }

  ColumnLayout {
    spacing: Globals.vars.marginCardSmall;

    Text {
      text: Utils.SysInfo.username;
      color: Globals.colours.fg;
      font.capitalization: Globals.menu.capitaliseUsername ? Font.Capitalize : undefined;
      // TODO: Replace the following with mainFont var:
      font.family: "Cascadia Code";
      font.pixelSize: 16;
      font.kerning: false;
    }

    Text {
      text: Utils.SysInfo.hostname;
      color: Globals.colours.fg;
      font.capitalization: Globals.menu.capitaliseHostname ? Font.Capitalize : undefined;
      // TODO: Replace the following with mainFont var:
      font.family: "Cascadia Code";
      font.pixelSize: 16;
      font.kerning: false;
    }
  }

  Item { Layout.fillWidth: true; }

  Text {
    text: "power icon"
    color: Globals.colours.fg;
    font: Globals.vars.mainFont;
  }
}

