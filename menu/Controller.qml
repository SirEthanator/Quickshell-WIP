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
import QtQuick.Effects;
import QtQuick.Layouts;
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
        loader.timer = Utils.Timeout.setTimeout(() => loader.activeAsync = false, Globals.vars.animLen)
      } else {
        loader.activeAsync = true;
      }
    }

    PanelWindow {
      id: root;
      color: "transparent";

      anchors {
        top: true;
        bottom: true;
        left: true;
      }

      implicitWidth: Globals.conf.menu.width;
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

        property int selectedAppIndex: 0;
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

          Shadow { padding: Globals.vars.gapLarge }

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
                    pixelSize: Globals.vars.mainFontSize
                  }

                  background: Rectangle { color: "transparent" }

                  placeholderText: "Search Applications"
                  placeholderTextColor: Globals.colours.grey

                  focusPolicy: Qt.ClickFocus;
                  onFocusChanged: {
                    if (focus) stack.currentIndex = 1
                    else clear()
                  }

                  onAccepted: launcher.execTop()
                }
              }
            }

            Stack {
              id: stack;
              Layout.fillHeight: true;
              Layout.fillWidth: true;

              Dashboard.Index {}
              Launcher.Index { id: launcher; searchText: appSearch.text }
            }
          }
        }
      }
    }
  }

  function init() {}
}

