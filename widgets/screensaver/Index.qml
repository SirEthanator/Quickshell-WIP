pragma ComponentBehavior: Bound

import qs.widgets.screensaver
import Quickshell;
import Quickshell.Wayland;
import QtQuick;
import Qt5Compat.GraphicalEffects;

LazyLoader {
  id: root;
  activeAsync: Controller.open;

  required property var screen;

  PanelWindow {
    id: win;
    screen: root.screen;
    color: "black";

    exclusionMode: ExclusionMode.Ignore;
    WlrLayershell.layer: WlrLayer.Overlay;
    WlrLayershell.keyboardFocus: WlrKeyboardFocus.Exclusive;

    anchors {
      top: true;
      bottom: true;
      left: true;
      right: true
    }

    MouseArea {
      anchors.fill: parent;
      cursorShape: Qt.BlankCursor;

      focus: true;
      Keys.onEscapePressed: Controller.open = false;
    }

    Image {
      id: logosrc;
      source: Quickshell.shellPath("assets/arch-full.svg");
      visible: false;
    }

    ColorOverlay {
      id: logo;
      readonly property list<color> colors: [
        "#FFFFFF", "#1793D1", "#DAF6F0",
        "#C6EC60", "#999498", "#BDF5C4",
        "#64AF9B", "#6C68A3", "#F1E39B",
        "#76EA8D", "#AEC3E6", "#76906F",
        "#E2C1C0", "#D8DB9D", "#91F2FE",
        "#B993D5", "#748DA7", "#7079E8"
      ];

      function getRandomColor() {
        return colors[Math.floor(Math.random() * colors.length)];
      }

      function changeColor() {
        let newColor;
        do {
          newColor = getRandomColor();
        } while (newColor === color);
        color = newColor;
      }

      width: logosrc.width;
      height: logosrc.height;

      x: 1;
      y: 1;

      source: logosrc;
      color: getRandomColor();
    }

    FrameAnimation {
      id: animation;

      function randint(min, max) {
        return Math.floor(Math.random() * (max - min + 1)) + min;
      }

      property int xSpeed: randint(340, 440);
      property int ySpeed: randint(310, 410);

      onTriggered: {
        if (logo.x <= 0 || logo.x >= win.width - logo.width) {
          logo.x = Math.max(0, Math.min(logo.x, win.width - logo.width));
          xSpeed *= -1;
          logo.changeColor();
        }
        logo.x += xSpeed * frameTime;

        if (logo.y <= 0 || logo.y >= win.height - logo.height) {
          logo.y = Math.max(0, Math.min(logo.y, win.height - logo.height));
          ySpeed *= -1;
          logo.changeColor();
        }
        logo.y += ySpeed * frameTime;
      }
    }
    Component.onCompleted: animation.start();
  }
}
