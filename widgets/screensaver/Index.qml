pragma ComponentBehavior: Bound

import "root:/";
import Quickshell;
import Quickshell.Wayland;
import QtQuick;
import Qt5Compat.GraphicalEffects;

LazyLoader {
  id: loader;
  activeAsync: show;
  required property var screen;
  required property bool show;
  signal hide;

  PanelWindow {
    id: root;
    screen: loader.screen;
    color: "transparent";

    exclusionMode: ExclusionMode.Ignore;
    WlrLayershell.layer: WlrLayer.Overlay;
    WlrLayershell.keyboardFocus: WlrKeyboardFocus.Exclusive;

    anchors {
      top: true;
      bottom: true;
      left: true;
      right: true
    }

    Item {
      anchors.fill: parent;
      focus: true;
      Keys.onEscapePressed: loader.hide();

      Rectangle {
        id: background;
        anchors.fill: parent;
        color: "black";

        MouseArea {
          anchors.fill: parent;
          cursorShape: Qt.BlankCursor;

          Image {
            id: logosrc;
            source: Qt.resolvedUrl("root:/assets/arch-full.svg");
            visible: false;
          }

          ColorOverlay {
            id: logo;
            readonly property list<color> colours: [
              "#FFFFFF", "#1793D1", "#DAF6F0",
              "#C6EC60", "#999498", "#BDF5C4",
              "#64AF9B", "#6C68A3", "#F1E39B",
              "#76EA8D", "#AEC3E6", "#76906F",
              "#E2C1C0", "#D8DB9D", "#91F2FE",
              "#B993D5", "#748DA7", "#7079E8"
            ];
            function changeColour() {
              color = colours[Math.floor(Math.random() * colours.length)];
            }

            anchors.fill: logosrc;
            source: logosrc;
            color: "white";
          }

          FrameAnimation {
            id: animation;
            readonly property int initialXSpeed: 400;
            readonly property int initialYSpeed: 350;
            property int xSpeed: initialXSpeed;
            property int ySpeed: initialYSpeed;
            onTriggered: {
              // We could just reverse xSpeed if either condition is true, but we don't in case the image goes slightly too far off screen
              // If it does, it would jitter and stay at the edge, since it keeps reversing because the condition is still true on the next frame
              if (logo.anchors.leftMargin >= background.width - logo.width) {
                xSpeed = -initialXSpeed; logo.changeColour();
              } else if (logo.anchors.leftMargin <= 0) {
                xSpeed = initialXSpeed; logo.changeColour();
              }
              logo.anchors.leftMargin += xSpeed * frameTime;
              logo.anchors.rightMargin -= xSpeed * frameTime;

              if (logo.anchors.topMargin >= background.height - logo.height) {
                ySpeed = -initialYSpeed; logo.changeColour();
              } else if (logo.anchors.topMargin <= 0) {
                ySpeed = initialYSpeed; logo.changeColour();
              }
              logo.anchors.topMargin += ySpeed * frameTime;
              logo.anchors.bottomMargin -= ySpeed * frameTime;
            }
          }
          Component.onCompleted: animation.start()  // Start when component is complete so that correct values are used
        }
      }
    }
  }
}
