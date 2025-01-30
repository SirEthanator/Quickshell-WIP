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
  active: Globals.states.sidebarOpen;

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

          MouseArea {
            implicitHeight: 100;
            Layout.fillWidth: true;
            Rectangle {  //!!! TEMP - User info: pfp, username, hostname, uptime and power buttons (similar to Vaxry's setup)
              color: "blueviolet";
              anchors.fill: parent;
            }
            onPressed: {
            }
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
              NumberAnimation { properties: "x"; from: replaceEnter.ViewTransition.item.width; duration: 400; easing.type: Easing.OutCubic }
              NumberAnimation { property: "opacity"; from: 0; to: 1; duration: 400; easing.type: Easing.OutCubic }
            }
            replaceExit: Transition {
              id: replaceExit
              NumberAnimation { properties: "x"; to: -replaceExit.ViewTransition.item.width; duration: 400; easing.type: Easing.OutCubic }
              NumberAnimation { property: "opacity"; from: 1; to: 0; duration: 400; easing.type: Easing.OutCubic }
            }
          }
        }
      }
    }

    Component {id: dashboard; Dashboard {}}
    Component {id: launcher; Launcher {}}
  }
}

