pragma ComponentBehavior: Bound

import qs.singletons
import qs.widgets.sidebar  // For LSP
import qs.components
import qs.widgets.menu.dashboard as NotifCentre;
import qs.animations as Anims;
import qs.widgets.polkit as Polkit;
import qs.widgets.menu as Menu;
import Quickshell;
import Quickshell.Wayland;
import Quickshell.Io;
import QtQuick;

Scope {
  id: root;

  IpcHandler {
    target: "menu";
    function toggle(): void { Controller.toggle("menu") }
  }

  Polkit.Polkit { id: polkit }

  Timer {
    id: unloadTimer;
    interval: Consts.animLen;
    repeat: false;

    onTriggered: {
      loader.activeAsync = false;
    }
  }

  LazyLoader {
    id: loader;
    activeAsync: false;

    property bool open: Controller.sidebarOpen;

    onOpenChanged: {
      if (open) {
        unloadTimer.stop();
        loader.activeAsync = true;
      } else {
        unloadTimer.restart();
      }
    }

    PanelWindow {
      color: Conf.sidebar.dimBackground ? Consts.bgDimmedColor : "transparent";

      anchors {
        top: true;
        bottom: true;
        left: true;
        right: true;
      }

      exclusionMode: ExclusionMode.Normal;
      WlrLayershell.layer: WlrLayer.Overlay;
      WlrLayershell.keyboardFocus: loader.open ? WlrKeyboardFocus.Exclusive : WlrKeyboardFocus.None;

      Anims.ColorAnim on color {
        running: Conf.sidebar.dimBackground && loader.open;
        from: "#00000000"; to: Consts.bgDimmedColor;
        duration: Consts.animLen;
      }

      Anims.ColorAnim on color {
        running: !loader.open && Conf.sidebar.dimBackground;
        to: "#00000000";
        duration: Consts.animLen;
      }

      Anims.Slide {
        running: !loader.loading && loader.open;
        target: wrapper;
        grow: true;
        slideOffset: 200;
      }

      MouseArea {
        anchors.fill: parent;
        onClicked: {
          Controller.deactivate(Controller.current);
        }
      }

      Anims.Slide {
        running: !loader.open;
        target: wrapper;
        reverse: true;
      }

      Item {
        id: wrapper;
        width: Conf.sidebar.width + Consts.gapLarge * 2;
        height: parent.height;

        Shadow { target: background }

        Keys.onEscapePressed: {
          Controller.deactivate(Controller.current);
        }

        OutlinedRectangle {
          id: background;

          anchors {
            fill: parent;
            margins: Consts.gapLarge;
          }

          color: Globals.colors.bg;
          radius: Consts.br;

          disableAllOutlines: !Conf.sidebar.backgroundOutline;

          MouseArea {
            // Prevent menu being closed when the content background is clicked
            anchors.fill: parent.content;
          }

          Stack {
            id: itemStack;
            anchors {
              fill: parent;
              margins: Consts.paddingWindow;
            }

            changeFocus: true;

            currentIndex: Controller.idIdxMap[Controller.current];

            SidebarItem {
              sourceComponent: Menu.Index {}
              identifier: "menu";
            }

            SidebarItem {
              sourceComponent: Polkit.Index { polkit: polkit }
              identifier: "polkit";
            }

            SidebarItem {
              sourceComponent: NotifCentre.NotifCentre {}
              identifier: "notifications";
            }
          }
        }
      }
    }
  }
}
