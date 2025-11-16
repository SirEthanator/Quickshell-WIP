import qs
import qs.utils as Utils;
import Quickshell;
import Quickshell.Wayland;
import QtQuick;
import QtQuick.Effects;

PanelWindow {
  WlrLayershell.layer: WlrLayer.Background;
  WlrLayershell.namespace: "blurred-wallpaper";
  exclusionMode: ExclusionMode.Ignore;
  color: Conf.desktop.bgColour;

  visible: Utils.Session.session === "niri";

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

