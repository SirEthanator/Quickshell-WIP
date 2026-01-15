pragma ComponentBehavior: Bound

import qs.singletons
import qs.utils as Utils;
import qs.components
import qs.animations as Anims;
import "dashboard" as Dashboard;
import "launcher" as Launcher;
import Quickshell;
import Quickshell.Wayland;
import Quickshell.Io;
import QtQuick;
import QtQuick.Layouts;
import QtQuick.Controls;

Scope {
  IpcHandler {
    target: "menu";
    function toggle(): void { Globals.states.menuOpen = !Globals.states.menuOpen }
  }

  LazyLoader {
    id: loader;
    activeAsync: false;

    property bool open: Globals.states.menuOpen;
    property var timer;
    onOpenChanged: {
      if (!!loader.timer) return
      if (open) {
        loader.activeAsync = true;
      } else {
        // We need a timer so the component will not be unloaded until the animation finishes
        loader.timer = Utils.Timeout.setTimeout(() => loader.activeAsync = false, Consts.animLen);
      }
    }

    PanelWindow {
      id: root;
      color: Conf.menu.dimBackground ? Consts.bgDimmedColour : "transparent";

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
        running: Conf.menu.dimBackground;
        from: "#00000000"; to: Consts.bgDimmedColour;
        duration: Consts.animLen;
      }

      Anims.ColourAnim on color {
        running: !loader.open && Conf.menu.dimBackground;
        to: "#00000000";
        duration: Consts.animLen;
      }

      Anims.Slide {
        running: !loader.loading;
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
        width: Conf.menu.width + Consts.gapLarge * 2;
        height: parent.height;
        focus: true;

        Keys.onPressed: (event) => {
          if (!loader.open) return;
          const key = event.key;
          if (key === Qt.Key_Tab && !event.isAutoRepeat) {
            stack.currentIndex++;
            appSearch.focus = false;
            focus = true;

          } else if (key === Qt.Key_Escape) {
            Globals.states.menuOpen = false;

          } else if ((key >= 48 && key <= 90) || (key >= 97 && key <= 122) || (key >= 186 && key <= 223)) {
            appSearch.focus = true;
            appSearch.field.insert(0, event.text);

          } else if (stack.currentIndex === 1) {
            if (key === Qt.Key_Return || key === Qt.Key_Enter) launcher.execSelected();
            if (key === Qt.Key_Down) launcher.down();
            if (key === Qt.Key_Up) launcher.up();
          }
        }

        Shadow { target: background }

        // Visible background of menu
        OutlinedRectangle {
          id: background;

          anchors {
            fill: parent;
            margins: Consts.gapLarge;
          }

          color: Globals.colours.bg;
          radius: Consts.br;

          disableAllOutlines: !Conf.menu.backgroundOutline;

          ColumnLayout {
            id: content;
            spacing: Consts.paddingWindow;
            clip: true;

            anchors {
              fill: parent;
              margins: Consts.paddingWindow;
            }

            Input {
              id: appSearch;
              Layout.fillWidth: true;

              showBorder: Conf.menu.moduleOutlines;

              icon: "search-symbolic";

              field: InputField {
                placeholderText: "Search Applications";
                focusPolicy: Qt.ClickFocus;
                onFocusChanged: {
                  if (focus) stack.currentIndex = 1
                  else clear();
                }
              }
            }

            FlickableStack {
              id: stack;
              Layout.fillHeight: true;
              Layout.fillWidth: true;
              loopOutOfRange: true;

              Dashboard.Index {}
              Launcher.Index { id: launcher; searchText: appSearch.field.text }
            }

            PageIndicator { stack: stack }  // Imported from components, not QtQuick.Controls
          }
        }
      }
    }
  }
}

