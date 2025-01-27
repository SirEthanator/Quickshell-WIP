import "root:/";
import Quickshell;
import QtQuick;
import QtQuick.Layouts;
import QtQuick.Controls;

PanelWindow {
  id: root;
  color: "transparent";

  anchors {
    top: true;
    bottom: true;
    left: true;
  }

  width: Opts.sidebar.width;
  visible: true;  //!!! TEMP
  //exclusionMode: ExclusionMode.Normal;  //!!! TEMP - Keeping it exclusive makes development easier

  // Visible background of sidebar
  Rectangle {
    anchors {
      fill: parent;
      margins: Opts.vars.gapLarge;
    }

    color: Opts.colours.bg;
    radius: Opts.vars.br;

    ColumnLayout {
      id: content;
      spacing: Opts.vars.paddingWindow;

      anchors {
        fill: parent;
        margins: Opts.vars.paddingWindow
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
        initialItem: Dashboard {}
        Layout.fillHeight: true;
        Layout.fillWidth: true;
      }
    }
  }
}

