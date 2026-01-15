pragma ComponentBehavior: Bound

import qs.singletons
import Quickshell;
import Quickshell.Wayland;
import QtQuick;
import QtQuick.Effects;

LazyLoader {
  id: root;
  activeAsync: Conf.desktop.backdropWallpaper;
  required property var screen;

  PanelWindow {
    WlrLayershell.layer: WlrLayer.Background;
    WlrLayershell.namespace: "backdrop-wallpaper";
    exclusionMode: ExclusionMode.Ignore;
    color: Conf.desktop.bgColour;

    screen: root.screen;

    anchors {
      top: true;
      bottom: true;
      left: true;
      right: true;
    }

    MultiEffect {
      anchors.fill: parent;
      source: wallpaper;

      brightness: -0.05
      saturation: 0.2;

      blurEnabled: true;
      blur: 1.0;
      blurMax: 64;
      blurMultiplier: 0.5;
    }

    Wallpaper { id: wallpaper; visible: false }
  }
}
