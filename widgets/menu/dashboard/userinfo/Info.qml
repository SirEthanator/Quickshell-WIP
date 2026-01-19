import qs.singletons
import qs.widgets.sidebar as Sidebar;
import qs.components
import Quickshell;
import QtQuick;
import QtQuick.Effects;
import QtQuick.Layouts;

RowLayout {
  id: root;
  spacing: Consts.paddingCard;
  signal clicked(event: MouseEvent);

  Item {
    id: pfp;

    visible: false;
    implicitWidth: 100;
    implicitHeight: 100;
    readonly property alias status: pfpImg.status;

    Image {
      id: pfpImg;
      readonly property url defaultPfpPath: Quickshell.shellPath("assets/profile.png");

      source: Conf.menu.profilePicture || defaultPfpPath;
      anchors.fill: parent;
      fillMode: Image.PreserveAspectCrop;

      onStatusChanged: {
        if (status === Image.Error || status === Image.Null) {
          source = defaultPfpPath;
        }
      }

      asynchronous: true
    }
  }

  Rectangle {
    id: loading;
    implicitHeight: 100;
    implicitWidth: 100;
    color: Globals.colours.bg;
    visible: false;
  }

  MultiEffect {
    source: pfp.status === Image.Ready ? pfp : loading;
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
    spacing: Consts.marginCardSmall;

    Text {
      text: SysInfo.username;
      color: Globals.colours.fg;
      font {
        family: Consts.fontFamily;
        pixelSize: Consts.headingFontSize;
        variableAxes: {
          "wght": 700,
          "wdth": 130
        }
      }
    }

    Text {
      text: SysInfo.hostname;
      color: Globals.colours.fg;
      font {
        family: Consts.fontFamily;
        pixelSize: Consts.mainFontSize;
      }
    }
  }

  Item { Layout.fillWidth: true; }

  Button {
    icon: "settings-symbolic";
    iconSize: Consts.largeIconSize;
    allRadius: true;

    onClicked: {
      Globals.launchConfMenu();
      Sidebar.Controller.deactivate("menu");
    }
  }

  Button {
    icon: "system-shutdown-symbolic";
    iconSize: Consts.largeIconSize;
    labelColour: Globals.colours.red;
    allRadius: true;
    bgPress: Globals.colours.red;

    onClicked: event => root.clicked(event);
  }
}
