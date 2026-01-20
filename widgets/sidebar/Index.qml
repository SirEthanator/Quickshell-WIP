pragma ComponentBehavior: Bound

import qs.singletons
import qs.widgets.sidebar  // For LSP
import qs.components
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
      color: Conf.sidebar.dimBackground ? Consts.bgDimmedColour : "transparent";

      anchors {
        top: true;
        bottom: true;
        left: true;
        right: true;
      }

      exclusionMode: ExclusionMode.Normal;
      WlrLayershell.layer: WlrLayer.Overlay;
      WlrLayershell.keyboardFocus: loader.open ? WlrKeyboardFocus.Exclusive : WlrKeyboardFocus.None;

      Anims.ColourAnim on color {
        running: Conf.sidebar.dimBackground && loader.open;
        from: "#00000000"; to: Consts.bgDimmedColour;
        duration: Consts.animLen;
      }

      Anims.ColourAnim on color {
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

        OutlinedRectangle {
          id: background;

          anchors {
            fill: parent;
            margins: Consts.gapLarge;
          }

          color: Globals.colours.bg;
          radius: Consts.br;

          disableAllOutlines: !Conf.sidebar.backgroundOutline;

          Stack {
            id: itemStack;
            anchors {
              fill: parent;
              margins: Consts.paddingWindow;
            }

            changeFocus: true;

            currentIndex: Controller.idIdxMap[Controller.current];

            Loader {
              sourceComponent: Menu.Index {}
              active: Controller.active.includes("menu") || Controller.finalActive === "menu";
            }

            Loader {
              sourceComponent: Polkit.Index { polkit: polkit }
              active: Controller.active.includes("polkit") || Controller.finalActive === "polkit";
            }
          }
        }
      }
    }
  }
}
