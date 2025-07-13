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
      source: "root:/assets/profile.png";
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
        family: Globals.vars.fontFamily;
        pixelSize: Globals.vars.headingFontSize;
      }
    }

    Text {
      text: Utils.SysInfo.hostname;
      color: Globals.colours.fg;
      font {
        family: Globals.vars.fontFamily;
        pixelSize: Globals.vars.mainFontSize;
      }
    }
  }

  Item { Layout.fillWidth: true; }

  Button {
    icon: "settings-symbolic";
    iconSize: Globals.vars.largeIconSize;
    allRadius: true;

    onClicked: {
      Globals.launchConfMenu();
      Globals.states.menuOpen = false;
    }
  }

  Button {
    icon: "system-shutdown-symbolic";
    iconSize: Globals.vars.largeIconSize;
    labelColour: Globals.colours.red;
    allRadius: true;
    bgPress: Globals.colours.red;

    onClicked: event => root.clicked(event);
  }
}
