import qs
import Quickshell;
import Quickshell.Wayland;
import QtQuick;

PanelWindow {
  WlrLayershell.layer: WlrLayer.Background;
  WlrLayershell.namespace: "wallpaper";
  exclusionMode: ExclusionMode.Ignore;
  color: Globals.conf.desktop.bgColour;

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
    color: Globals.conf.desktop.bgColour;
    SequentialAnimation on opacity {
      NumberAnimation {
        from: 1; to: 0;
        duration: Globals.conf.desktop.fadeSpeed;
        easing.type: Easing.OutCubic;
      }
      PropertyAction { target: fadeOverlay; property: "visible"; value: false }
    }
  }
}

