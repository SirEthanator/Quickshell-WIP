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

  Rectangle {
    id: pfp;

    visible: false;
    implicitWidth: 100;
    implicitHeight: 100;
    readonly property alias status: pfpImg.status;

    color: Globals.colors.bg;

    readonly property bool useDefault: !Conf.menu.profilePicture || status === Image.Error || status === Image.Null;

    Image {
      id: pfpImg;

      source: pfp.useDefault ? Quickshell.shellPath("assets/arch-icon.svg") : Conf.menu.profilePicture;

      anchors.fill: parent;
      anchors.margins: pfp.useDefault ? 20 : 0;

      fillMode: Image.PreserveAspectCrop;

      asynchronous: true
    }
  }

  MultiEffect {
    source: pfp;
    implicitHeight: pfp.height;
    implicitWidth: pfp.width;
    maskEnabled: true;
    maskSource: pfpMask;

    colorization: pfp.useDefault ? 1 : 0;
    colorizationColor: Globals.colors.accent;
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
      color: Globals.colors.fg;
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
      color: Globals.colors.fg;
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
    labelColor: Globals.colors.red;
    allRadius: true;
    bgPress: Globals.colors.red;

    onClicked: event => root.clicked(event);
  }
}
