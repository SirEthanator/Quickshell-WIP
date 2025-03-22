import "root:/";
import "widgets" as Widgets;
import Quickshell;
import Quickshell.Wayland;
import QtQuick;

PanelWindow {
  WlrLayershell.layer: WlrLayer.Background;
  exclusionMode: ExclusionMode.Ignore;
  color: Globals.conf.background.bgColour;

  anchors {
    top: true;
    bottom: true;
    left: true;
    right: true;
  }

  Loader {
    active: Globals.conf.background.autohideWidgets || Globals.conf.background.autohideBar || Globals.conf.background.autohideCursor;
    asynchronous: true;
    sourceComponent: children[0];
    anchors.fill: parent;

    MouseArea {
      id: mouseArea;
      anchors.fill: parent;
      hoverEnabled: true;

      // Bar will only be hidden if the background has focus, but widgets will be hidden regardless of whether the background is focused or not

      function mouseMove() {
        if (Globals.conf.background.autohideCursor) {
          cursorHideTimer.restart();
          mouseArea.cursorShape = Qt.ArrowCursor;
        }
        if (Globals.conf.background.autohideWidgets || Globals.conf.background.autohideBar) {
          widgetAndBarHideTimer.restart();
          widgets.show();
          Globals.states.barHidden = false;
        }
      }

      onContainsMouseChanged: if (!containsMouse) Globals.states.barHidden = false;

      onMouseXChanged: mouseMove();
      onMouseYChanged: mouseMove();

      Timer {
        id: cursorHideTimer;
        interval: 5000;
        onTriggered: if (Globals.conf.background.autohideCursor) mouseArea.cursorShape = Qt.BlankCursor;
      }

      Timer {
        id: widgetAndBarHideTimer;
        interval: 20_000;
        onTriggered: {
          if (Globals.conf.background.autohideWidgets) widgets.hide();
          if (Globals.conf.background.autohideBar && mouseArea.containsMouse) Globals.states.barHidden = true;
        }
      }
    }
  }

  Wallpaper {}

  Widgets.Index { id: widgets }

  Rectangle {
    id: fadeOverlay;
    anchors.fill: parent;
    color: Globals.conf.background.bgColour;
    SequentialAnimation on opacity {
      NumberAnimation {
        from: 1; to: 0;
        duration: Globals.conf.background.fadeSpeed;
        easing.type: Easing.OutCubic;
      }
      PropertyAction { target: fadeOverlay; property: "visible"; value: false }
    }
  }
}

