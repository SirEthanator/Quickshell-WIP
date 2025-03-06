import "root:/";
import Quickshell;
import Quickshell.Widgets;
import Quickshell.Services.SystemTray;
import QtQuick;
import QtQuick.Layouts;

DashItem {
  id: root;

  GridLayout {
    id: trayButtons;
    rowSpacing: Globals.vars.marginCard;
    columnSpacing: Globals.vars.marginCard;

    Repeater {
      model: SystemTray.items;

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

          anchor.window: trayItem.QsWindow.window;
          anchor.adjustment: PopupAdjustment.Flip;

          anchor.onAnchoring: {
            const win = trayItem.QsWindow.window;
            const widgetRect = win.contentItem.mapFromItem(trayItem, 0, trayItem.height, trayItem.width, trayItem.height);

            menuAnchor.anchor.rect = widgetRect;
          }
        }
      }
    }
  }
}

