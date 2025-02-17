import "root:/";
import "root:/utils" as Utils;
import "..";
import QtQuick;
import QtQuick.Effects;
import QtQuick.Layouts;

RowLayout {
  Layout.fillWidth: true;
  Layout.fillHeight: true;
  spacing: Globals.vars.paddingCard;
  property alias powerHovered: powerIconMouse.containsMouse;

  Image {
    id: pfp;
    source: "root:/pfp.png";
    sourceSize.width: 100;
    sourceSize.height: 100;
    visible: false;
  }

  MultiEffect {
    source: pfp;
    implicitHeight: pfp.height;
    implicitWidth: pfp.width;
    maskEnabled: true;
    maskSource: circleMask;
    layer.smooth: true;
    maskThresholdMin: 0.5;
    maskSpreadAtMin: 1;
  }

  Item {
    id: circleMask;
    implicitWidth: pfp.width;
    implicitHeight: pfp.height;
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

  MouseArea {
    id: powerIconMouse;
    implicitHeight: powerIcon.height;
    implicitWidth: powerIcon.width;
    hoverEnabled: true;

    Icon {
      id: powerIcon;
      icon: "system-shutdown-symbolic"
      colour: Globals.colours.red;
      size: 32;
    }
  }
}
