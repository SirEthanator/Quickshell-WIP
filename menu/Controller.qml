pragma Singleton
pragma ComponentBehavior: Bound

import "root:/";
import "root:/utils" as Utils;
import "root:/components";
import "root:/animations" as Anims;
import "dashboard" as Dashboard;
import "launcher" as Launcher;
import Quickshell;
import Quickshell.Wayland;
import Quickshell.Io;
import QtQuick;
import QtQuick.Layouts;
import QtQuick.Effects;
import QtQuick.Controls;

Singleton {
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
      if (!open) {
        // We need a timer so the component will not be unloaded until the animation finishes
        loader.timer = Utils.Timeout.setTimeout(() => loader.activeAsync = false, Globals.vars.animLen);
      } else {
        loader.activeAsync = true;
      }
    }

    PanelWindow {
      id: root;
      color: Globals.conf.menu.dimBackground ? Globals.vars.menuDimmedColour : "transparent";

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
        running: Globals.conf.menu.dimBackground;
        from: "#00000000"; to: Globals.vars.menuDimmedColour;
        duration: Globals.vars.animLen;
      }

      Anims.ColourAnim on color {
        running: !loader.open && Globals.conf.menu.dimBackground;
        to: "#00000000";
        duration: Globals.vars.animLen;
      }

      Anims.SlideFade {
        running: !loader.loading;
        target: wrapper;
      }

      Anims.SlideFade {
        running: !loader.open;
        target: wrapper;
        reverse: true;
      }

      Item {
        id: wrapper;
        width: Globals.conf.menu.width + Globals.vars.gapLarge * 2;
        height: parent.height;
        focus: true;

        Keys.onPressed: (event) => {
          const key = event.key;
          if (key === Qt.Key_Tab) {
            stack.currentIndex++;
            appSearch.focus = false;
            focus = true;
          } else if (key === Qt.Key_Escape) {
            Globals.states.menuOpen = false;
          } else if ((key >= 48 && key <= 90) || (key >= 97 && key <= 122) || (key >= 186 && key <= 223)) {
            appSearch.insert(0, event.text);
            appSearch.focus = true;
          } else if (stack.currentIndex === 1) {
            if (key === Qt.Key_Return || key === Qt.Key_Enter) launcher.execSelected();
            if (key === Qt.Key_Down) launcher.down();
            if (key === Qt.Key_Up) launcher.up();
          }
        }

        RectangularShadow {
          anchors.fill: background;
          radius: background.radius;
          blur: 25;
          spread: -3;
          color: Qt.darker(background.color, 1.5);
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

          border {
            color: Globals.conf.menu.backgroundOutline ? Globals.colours.outline : "transparent";
            width: Globals.conf.menu.backgroundOutline ? Globals.vars.outlineSize : 0;
            pixelAligned: false;
          }

          ColumnLayout {
            id: content;
            spacing: Globals.vars.paddingWindow;
            clip: true;

            anchors {
              fill: parent;
              margins: Globals.vars.paddingWindow;
            }

            // Application search bar
            Rectangle {
              id: appSearchBg;
              color: Globals.colours.bgLight;
              radius: Globals.vars.br;

              border {
                color: Globals.conf.menu.moduleOutlines ? Globals.colours.outline : "transparent";
                width: Globals.conf.menu.moduleOutlines ? Globals.vars.outlineSize : 0;
                pixelAligned: false;
              }

              implicitHeight: appSearch.height + Globals.vars.paddingButton * 2;
              Layout.fillWidth: true;

              RowLayout {
                spacing: Globals.vars.paddingButton;
                anchors.fill: parent;

                Item {}

                Icon {
                  icon: "search-symbolic";
                  color: Globals.colours.fg;
                  Layout.alignment: Qt.AlignVCenter;
                }

                TextField {
                  id: appSearch;
                  Layout.fillWidth: true;
                  color: Globals.colours.fg;
                  font {
                    family: Globals.vars.fontFamily;
                    pixelSize: Globals.vars.mainFontSize;
                  }

                  background: Rectangle { color: "transparent" }

                  placeholderText: "Search Applications";
                  placeholderTextColor: Globals.colours.grey;

                  focusPolicy: Qt.ClickFocus;
                  onFocusChanged: {
                    if (focus) stack.currentIndex = 1
                    else clear();
                  }
                }
              }
            }

            Stack {
              id: stack;
              Layout.fillHeight: true;
              Layout.fillWidth: true;
              loopOutOfRange: true;

              Dashboard.Index {}
              Launcher.Index { id: launcher; searchText: appSearch.text }
            }

            PageIndicator { stack: stack }  // Imported from components, not QtQuick.Controls
          }
        }
      }
    }
  }

  function init() {}
}

