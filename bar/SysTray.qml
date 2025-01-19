pragma ComponentBehavior: Bound;

import "..";
import Quickshell;
import Quickshell.Widgets;
import Quickshell.Services.SystemTray;
import QtQuick;
import QtQuick.Layouts;
import org.kde.kirigami as Kirigami;

BarModule {
  id: root;
  required property var window;

  hoverEnabled: true;
  background: root.mouseArea.containsMouse ? Opts.colours.bgHover : Opts.colours.bgLight;
  onClicked: event => {
    popupLoader.active = !popupLoader.active;
  }

  Kirigami.Icon {
    Layout.alignment: Qt.AlignCenter;

    source: "down-symbolic";
    fallback: "error-symbolic";
    isMask: true;
    color: Opts.colours.fg;
    roundToIconSize: false;
    implicitWidth: Opts.vars.moduleIconSize;
    implicitHeight: Opts.vars.moduleIconSize;
  }

  LazyLoader {
    id: popupLoader;

    PopupWindow {
      id: popup;

      anchor {
        window: root.window;
        rect.y: root.window.height + Opts.vars.gapLarge;
        edges: Edges.Top;
        gravity: Edges.Bottom;
        onAnchoring: {
          popup.anchor.rect.x = popup.anchor.window.contentItem.mapFromItem(root, root.width / 2, 0).x;
        }
      }
      visible: true;

      // width: trayButtons.width;
      // height: trayButtons.height;

      GridLayout {
        id: trayButtons;
        columns: 3;

        Repeater {
          model: SystemTray.items;

          MouseArea {
            id: delegate;
            required property SystemTrayItem modelData;
            property alias item: delegate.modelData;

            implicitWidth: icon.implicitWidth;
            implicitHeight: icon.implicitHeight;
            acceptedButtons: Qt.LeftButton | Qt.RightButton | Qt.MiddleButton;
            hoverEnabled: true;

            onClicked: event => {
              if (event.button == Qt.LeftButton) {
                item.activate();
              } else if (event.button == Qt.MiddleButton) {
                item.secondaryActivate();
              } else if (event.button == Qt.RightButton && item.hasMenu) {
                menuAnchor.open();
              }
            }

            onWheel: event => {
              event.accepted = true;
              const points = event.angleDelta.y / 120;
              item.scroll(points, false);
            }

            IconImage {
              id: icon
              anchors.centerIn: parent;
              source: delegate.item.icon;

              implicitSize: 32;
            }

            QsMenuAnchor {
              id: menuAnchor;
              menu: delegate.item.menu;

              anchor.window: delegate.QsWindow.window;
              anchor.adjustment: PopupAdjustment.Flip;

              anchor.onAnchoring: {
                const win = delegate.QsWindow.window;
                const widgetRect = win.contentItem.mapFromItem(delegate, 0, delegate.height, delegate.width, delegate.height);

                menuAnchor.anchor.rect = widgetRect;
              }
            }
          }
        }
      }

    }
  }
}

