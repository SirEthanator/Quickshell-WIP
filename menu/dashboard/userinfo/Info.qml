import "root:/";
import "root:/utils" as Utils;
import Quickshell.Widgets;
import QtQuick;
import QtQuick.Layouts;

RowLayout {
  Layout.fillWidth: true;
  Layout.fillHeight: true;
  spacing: Globals.vars.paddingCard;
  property alias powerHovered: powerIconMouse.containsMouse;

  ClippingWrapperRectangle {
    width: pfp.width;
    height: pfp.height;
    radius: width / 2;

    Image {
      id: pfp;
      source: "root:/pfp.png";
      sourceSize.width: 100;
      sourceSize.height: 100;
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
