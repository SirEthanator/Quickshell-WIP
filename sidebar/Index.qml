pragma ComponentBehavior: Bound;

import "root:/";
import Quickshell;
import Quickshell.Wayland;
import QtQuick;
import QtQuick.Layouts;
import QtQuick.Controls;

LazyLoader {
  id: loader;
  required property var screen;
  activeAsync: false;

  property bool open: Globals.states.sidebarOpen;
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

    width: Globals.sidebar.width;
    focusable: true;
    exclusionMode: ExclusionMode.Normal;
    WlrLayershell.layer: WlrLayer.Overlay;
    WlrLayershell.keyboardFocus: WlrKeyboardFocus.Exclusive;

    Item {
      anchors.fill: parent;
      focus: true;

      Keys.onPressed: (event) => {
        if (event.key === Qt.Key_Tab) {
          //!!! TEMP - Surely there's a better way of doing this (including not using the components):
          if ( stack.currentItem.toString().includes("Dashboard") ) stack.replace(launcher)
          else stack.replace(dashboard)
        }
        if (event.key === Qt.Key_Escape) {
          Globals.states.sidebarOpen = false;
        }
      }

      // Visible background of sidebar
      Rectangle {
        id: background;

        anchors {
          fill: parent;
          margins: Globals.vars.gapLarge;
        }

        color: Globals.colours.bg;
        radius: Globals.vars.br;

        NumberAnimation {  // Open animation
          running: true;
          target: background;
          property: "opacity";
          from: 0; to: 1;
          easing.type: Easing.OutCubic;
          duration: Globals.vars.animLen;
        }

        NumberAnimation {  // Close animation
          running: !loader.open;
          target: background;
          property: "opacity";
          from: 1; to: 0;
          easing.type: Easing.OutCubic;
          duration: Globals.vars.animLen;
        }

        ColumnLayout {
          id: content;
          spacing: Globals.vars.paddingWindow;
          clip: true;

          anchors {
            fill: parent;
            margins: Globals.vars.paddingWindow
          }

          Rectangle {  //!!! TEMP - User info: pfp, username, hostname, uptime and power buttons (similar to Vaxry's setup)
            color: "blueviolet";
            implicitHeight: 100;
            Layout.fillWidth: true;
          }

          Rectangle {  //!!! TEMP - Search bar
            color: "mediumslateblue";
            implicitHeight: 50;
            Layout.fillWidth: true;
          }

          StackView {
            id: stack;
            initialItem: dashboard;
            Layout.fillHeight: true;
            Layout.fillWidth: true;

            replaceEnter: Transition {
              id: replaceEnter
              NumberAnimation { properties: "x"; from: replaceEnter.ViewTransition.item.width; duration: Globals.vars.animLen; easing.type: Easing.OutCubic }
              NumberAnimation { property: "opacity"; from: 0; to: 1; duration: Globals.vars.animLen; easing.type: Easing.OutCubic }
            }
            replaceExit: Transition {
              id: replaceExit
              NumberAnimation { properties: "x"; to: -replaceExit.ViewTransition.item.width; duration: Globals.vars.animLen; easing.type: Easing.OutCubic }
              NumberAnimation { property: "opacity"; from: 1; to: 0; duration: Globals.vars.animLen; easing.type: Easing.OutCubic }
            }
          }
        }
      }
    }

    Component {id: dashboard; Dashboard {}}
    Component {id: launcher; Launcher {}}
  }
}

