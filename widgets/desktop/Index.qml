pragma ComponentBehavior: Bound

import qs
import Quickshell;
import Quickshell.Wayland;
import QtQuick;

LazyLoader {
  id: root;
  activeAsync: true;

  required property var screen;

  PanelWindow {
    WlrLayershell.layer: WlrLayer.Background;
    WlrLayershell.namespace: "wallpaper";
    exclusionMode: ExclusionMode.Ignore;
    color: Conf.desktop.bgColour;

    screen: root.screen;

    anchors {
      top: true;
      bottom: true;
      left: true;
      right: true;
    }

    Wallpaper {}

    Rectangle {
      id: fadeOverlay;
      anchors.fill: parent;
      color: Conf.desktop.bgColour;
      SequentialAnimation on opacity {
        NumberAnimation {
          from: 1; to: 0;
          duration: Conf.desktop.fadeSpeed;
          easing.type: Easing.OutCubic;
        }
        PropertyAction { target: fadeOverlay; property: "visible"; value: false }
      }
    }
  }
}

