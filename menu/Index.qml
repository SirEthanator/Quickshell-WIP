pragma ComponentBehavior: Bound

import "root:/";
import "root:/animations" as Anims;
import "dashboard" as Dashboard;
import "launcher" as Launcher;
import Quickshell;
import Quickshell.Wayland;
import QtQuick;
import QtQuick.Layouts;
import QtQuick.Controls;

LazyLoader {
  id: loader;
  required property var screen;
  required property var shellroot;
  activeAsync: false;

  property bool open: Globals.states.menuOpen;
  property var timer;
  onOpenChanged: {
    if (!!loader.timer) return
    if (!open) {
      // We need a timer so the component will not be unloaded until the animation finishes
      loader.timer = Qt.createQmlObject("import QtQuick; Timer {}", loader);
      timer.interval = Globals.vars.animLen;
      timer.triggered.connect(() => {
        loader.timer = null;
        loader.activeAsync = false
      });
      timer.start();
    } else {
      loader.activeAsync = true;
    }
  }

  PanelWindow {
    id: root;
    screen: loader.screen;
    color: "transparent";

    anchors {
      top: true;
      bottom: true;
      left: true;
    }

    width: Globals.menu.width;
    exclusionMode: ExclusionMode.Normal;
    WlrLayershell.layer: WlrLayer.Overlay;
    WlrLayershell.keyboardFocus: loader.open ? WlrKeyboardFocus.Exclusive : WlrKeyboardFocus.None;

    Anims.SlideFade {
      running: !loader.loading;
      slideTarget: root;
      fadeTarget: background;
    }

    Anims.SlideFade {
      running: !loader.open;
      slideTarget: root;
      fadeTarget: background;
      reverse: true;
    }

    Item {
      anchors.fill: parent;
      focus: true;

      Keys.onPressed: (event) => {
        const key = event.key;
        if (key === Qt.Key_Tab) {
          stack.currentIndex += 1;
          appSearch.focus = false;
          focus = true;
        } else if (key === Qt.Key_Escape) {
          Globals.states.menuOpen = false;
        } else if ((key >= 48 && key <= 90) || (key >= 97 && key <= 122) || (key >= 186 && key <= 223)) {
          appSearch.insert(0, event.text);
          appSearch.focus = true;
        }
      }

      // Visible background of menu
      Rectangle {
        id: background;

        anchors {
          fill: parent;
          margins: Globals.vars.gapLarge;
        }

        color: Globals.colours.bg;
        radius: Globals.vars.br;

        ColumnLayout {
          id: content;
          spacing: Globals.vars.paddingWindow;
          clip: true;

          anchors {
            fill: parent;
            margins: Globals.vars.paddingWindow
          }

          // Application search bar
          Rectangle {
            id: appSearchBg;
            color: Globals.colours.bgLight;
            radius: Globals.vars.br;
            implicitHeight: appSearch.height + Globals.vars.paddingButton * 2;
            Layout.fillWidth: true;

            TextInput {
              id: appSearch;
              width: parent.width - Globals.vars.paddingButton * 2;
              anchors.centerIn: parent;
              color: Globals.colours.fg;

              onFocusChanged: {
                if (focus) stack.currentIndex = 1
                else clear()
              }

              onAccepted: {
                Globals.states.menuOpen = false;
                launcher.execTop();
              }
            }
          }

          Stack {
            id: stack;
            Layout.fillHeight: true;
            Layout.fillWidth: true;

            Dashboard.Index { shellroot: loader.shellroot; screen: root.screen }
            Launcher.Index { id: launcher; searchText: appSearch.text }
          }
        }
      }
    }
  }
}

