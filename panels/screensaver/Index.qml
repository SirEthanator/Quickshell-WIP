pragma ComponentBehavior: Bound

import qs.panels.screensaver
import qs.widgets.screensaver as Screensaver;
import Quickshell;
import Quickshell.Wayland;
import QtQuick;

LazyLoader {
  id: root;
  activeAsync: Controller.open;

  required property var screen;

  PanelWindow {
    id: win;
    screen: root.screen;

    exclusionMode: ExclusionMode.Ignore;
    WlrLayershell.layer: WlrLayer.Overlay;
    WlrLayershell.keyboardFocus: WlrKeyboardFocus.Exclusive;

    anchors {
      top: true;
      bottom: true;
      left: true;
      right: true
    }

    Screensaver.Index {
      anchors.fill: parent;
    }
  }
}
