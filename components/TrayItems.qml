pragma ComponentBehavior: Bound

import Quickshell;
import Quickshell.Widgets;
import Quickshell.Services.SystemTray;
import QtQuick;

Repeater {
  id: root;
  model: SystemTray.items;
  property var window;

  MouseArea {
    id: trayItem;
    required property SystemTrayItem modelData;

    implicitWidth: icon.implicitWidth;
    implicitHeight: icon.implicitHeight;
    acceptedButtons: Qt.LeftButton | Qt.RightButton | Qt.MiddleButton;
    hoverEnabled: true;

    onClicked: event => {
      if (event.button == Qt.LeftButton) {
        modelData.activate();
      } else if (event.button == Qt.MiddleButton) {
        modelData.secondaryActivate();
      } else if (event.button == Qt.RightButton && modelData.hasMenu) {
        menuAnchor.open();
      }
    }

    onWheel: event => {
      event.accepted = true;
      const points = event.angleDelta.y / 120;
      modelData.scroll(points, false);
    }

    IconImage {
      id: icon;
      anchors.fill: parent;
      source: trayItem.modelData.icon;
      implicitSize: 24;
    }

    QsMenuAnchor {
      id: menuAnchor;
      menu: trayItem.modelData.menu;

      anchor.window: root.window ?? trayItem.QsWindow.window;
      anchor.adjustment: PopupAdjustment.Flip;

      anchor.onAnchoring: {
        const win = root.window ?? trayItem.QsWindow.window;
        const widgetRect = win.contentItem.mapFromItem(trayItem, 0, trayItem.height, trayItem.width, trayItem.height);

        menuAnchor.anchor.rect = widgetRect;
      }
    }
  }
}
