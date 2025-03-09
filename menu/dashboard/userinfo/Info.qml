import "root:/";
import "root:/components";
import "root:/utils" as Utils;
import Quickshell.Widgets;
import QtQuick;
import QtQuick.Layouts;

RowLayout {
  id: root;
  anchors.left: parent.left;
  anchors.right: parent.right;
  spacing: Globals.vars.paddingCard;
  signal clicked(event: MouseEvent);

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
      font {
        capitalization: Globals.menu.capitaliseUsername ? Font.Capitalize : undefined;
        family: Globals.vars.fontFamily;
        pixelSize: Globals.vars.headingFontSize;
      }
    }

    Text {
      text: Utils.SysInfo.hostname;
      color: Globals.colours.fg;
      font {
        capitalization: Globals.menu.capitaliseHostname ? Font.Capitalize : undefined;
        family: Globals.vars.fontFamily;
        pixelSize: Globals.vars.mainFontSize;
      }
    }
  }

  Item { Layout.fillWidth: true; }

  MouseArea {
    id: powerIconMouse;
    implicitHeight: powerIcon.height;
    implicitWidth: powerIcon.width;
    onClicked: event => root.clicked(event);

    Icon {
      id: powerIcon;
      icon: "system-shutdown-symbolic"
      colour: Globals.colours.red;
      size: 32;
    }
  }
}
