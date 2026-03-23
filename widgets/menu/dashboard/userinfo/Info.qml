import qs.singletons
import qs.panels.sidebar as Sidebar;
import qs.panels.settings as Settings;
import qs.components
import Quickshell;
import QtQuick;
import QtQuick.Effects;
import QtQuick.Layouts;

RowLayout {
  id: root;
  spacing: Consts.paddingLarge;
  signal clicked(event: MouseEvent);

  Rectangle {
    id: pfp;

    visible: false;
    implicitWidth: 100;
    implicitHeight: 100;
    readonly property alias status: pfpImg.status;

    color: Colors.c.bg;

    property bool useDefault: !Conf.menu.profilePicture;

    Image {
      id: pfpImg;

      source: pfp.useDefault ? Quickshell.shellPath("assets/arch-icon.svg") : Conf.menu.profilePicture;

      anchors.fill: parent;
      anchors.margins: pfp.useDefault ? 20 : 0;

      fillMode: Image.PreserveAspectCrop;

      asynchronous: true

      onStatusChanged: {
        if (status === Image.Error || status === Image.Null)
          pfp.useDefault = true;
      }
    }
  }

  MultiEffect {
    source: pfp;
    implicitHeight: pfp.height;
    implicitWidth: pfp.width;
    maskEnabled: true;
    maskSource: pfpMask;

    colorization: pfp.useDefault ? 1 : 0;
    colorizationColor: Colors.c.accent;
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
    spacing: Consts.paddingXSmall;

    Text {
      text: SysInfo.username;
      color: Colors.c.fg;
      font {
        family: Consts.fontFamMain;
        pixelSize: Consts.fontSizeLarge;
        variableAxes: {
          "wght": 700,
          "wdth": 130
        }
      }
    }

    Text {
      text: SysInfo.hostname;
      color: Colors.c.fg;
      font {
        family: Consts.fontFamMain;
        pixelSize: Consts.fontSizeMain;
      }
    }
  }

  Item { Layout.fillWidth: true; }

  Button {
    icon: "settings-symbolic";
    iconSize: Consts.iconSizeLarge;
    allRadius: true;

    onClicked: {
      Settings.Controller.open = true;
      Sidebar.Controller.deactivate("menu");
    }
  }

  Button {
    icon: "system-shutdown-symbolic";
    iconSize: Consts.iconSizeLarge;
    labelColor: Colors.c.red;
    allRadius: true;
    bgPress: Colors.c.red;

    onClicked: event => root.clicked(event);
  }
}
