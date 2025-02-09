pragma ComponentBehavior: Bound;

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
    focusable: true;
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
        if (event.key === Qt.Key_Tab) {
          if (stack.animPlaying) return;  //!!! Do nothing if animation is in progress - Currently switching too fast will make the active item invisible (need to fix)
          if (stack.currentIndex < stack.count - 1) stack.currentIndex += 1
          else stack.currentIndex = 0;
        }
        if (event.key === Qt.Key_Escape) {
          Globals.states.menuOpen = false;
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

          Rectangle {  //!!! TEMP - Search bar
            color: "mediumslateblue";
            implicitHeight: 50;
            Layout.fillWidth: true;
          }

          Stack {
            id: stack;
            Layout.fillHeight: true;
            Layout.fillWidth: true;

            currentIndex: 0;
            Dashboard.Index {}
            Launcher.Index {}
          }
        }
      }
    }
  }
}

