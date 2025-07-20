import qs
import qs.components
import qs.utils as Utils;
import Quickshell;
import QtQuick;
import QtQuick.Effects;
import QtQuick.Layouts;

RowLayout {
  id: root;
  anchors.left: parent.left;
  anchors.right: parent.right;
  spacing: Globals.vars.paddingCard;
  signal clicked(event: MouseEvent);

  Image {
    id: pfp;
    source: Quickshell.configPath("assets/profile.png");
    sourceSize.width: 100;
    sourceSize.height: 100;
    visible: false;
  }

  MultiEffect {
    source: pfp;
    implicitHeight: pfp.height;
    implicitWidth: pfp.width;
    maskEnabled: true;
    maskSource: pfpMask;
  }

  Rectangle {
    id: pfpMask
    implicitWidth: pfp.width;
    implicitHeight: pfp.height;

    radius: width/2;
    visible: false;
    layer.enabled: true;
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
