pragma ComponentBehavior: Bound

import qs
import qs.utils as Utils;
import Quickshell;
import Quickshell.Wayland;
import QtQuick;
import QtQuick.Layouts;

LazyLoader {
  id: loader;

  active: overlayOpen;

  signal close;
  required property var screen;
  required property bool switchInProgress;
  required property bool overlayOpen;
  required property string currentAction;

  PanelWindow {
    id: root;
    screen: loader.screen;

    color: "transparent";

    exclusionMode: ExclusionMode.Ignore;
    WlrLayershell.layer: WlrLayer.Overlay;

    anchors {
      top: true;
      bottom: true;
      left: true;
      right: true;
    }

    Rectangle {
      id: rectangle;
      color: Globals.colours.bg;
      height: root.height;
      width: root.width;

      NumberAnimation {
        id: fadeInAnim;

        // Using this instead of setting running to true prevents it from trying to play after reload.
        readonly property var switchInProgress: loader.switchInProgress;
        onSwitchInProgressChanged: { if (switchInProgress) start() }

        target: rectangle;
        property: "opacity";
        from: 0; to: 1;
        duration: 400;
        easing.type: Easing.Linear;
      }

      NumberAnimation {
        running: !loader.switchInProgress && !fadeInAnim.running;
        target: rectangle;
        property: "opacity";
        from: 1; to: 0;
        duration: 800;
        easing.type: Easing.Linear;

        onFinished: {
          loader.close();
        }
      }

      ColumnLayout {
        anchors.centerIn: parent;
        spacing: Globals.vars.paddingCard;

        Text {
          text: "Switching theme";
          Layout.alignment: Qt.AlignHCenter;
          font {
            family: Globals.vars.fontFamily;
            pixelSize: Globals.vars.headingFontSize;
          }
          color: Globals.colours.fg;
        }

        Text {
          text: loader.currentAction;
          Layout.alignment: Qt.AlignHCenter;
          font {
            family: Globals.vars.fontFamily;
            pixelSize: Globals.vars.mainFontSize;
          }
          color: Globals.colours.fg;
        }
      }
    }
  }
}

