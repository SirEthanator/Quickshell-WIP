import "root:/";
import "widgets" as Widgets;
import Quickshell;
import Quickshell.Wayland;
import QtQuick;

PanelWindow {
  WlrLayershell.layer: WlrLayer.Background;
  exclusionMode: ExclusionMode.Ignore;
  color: Globals.conf.desktop.bgColour;

  anchors {
    top: true;
    bottom: true;
    left: true;
    right: true;
  }

  Component {
    id: mouseAreaComponent;

    MouseArea {
      id: mouseArea;
      anchors.fill: parent;
      hoverEnabled: true;

      // Bar will only be hidden if the desktop has focus, but widgets will be hidden regardless of whether the desktop is focused or not

      function mouseMove() {
        if (Globals.conf.desktop.autohideCursor) {
          cursorHideTimer.restart();
          mouseArea.cursorShape = Qt.ArrowCursor;
        }
        if (Globals.conf.desktop.autohideWidgets || Globals.conf.desktop.autohideBar) {
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
        onTriggered: if (Globals.conf.desktop.autohideCursor) mouseArea.cursorShape = Qt.BlankCursor;
      }

      Timer {
        id: widgetAndBarHideTimer;
        interval: 20_000;
        onTriggered: {
          if (Globals.conf.desktop.autohideWidgets) widgets.hide();
          if (Globals.conf.desktop.autohideBar && mouseArea.containsMouse) Globals.states.barHidden = true;
        }
      }
    }
  }

  Loader {
    active: Globals.conf.desktop.autohideWidgets || Globals.conf.desktop.autohideBar || Globals.conf.desktop.autohideCursor;
    asynchronous: true;
    sourceComponent: mouseAreaComponent;
    anchors.fill: parent;
  }

  Wallpaper {}

  Widgets.Index { id: widgets }

  Rectangle {
    id: fadeOverlay;
    anchors.fill: parent;
    color: Globals.conf.desktop.bgColour;
    SequentialAnimation on opacity {
      NumberAnimation {
        from: 1; to: 0;
        duration: Globals.conf.desktop.fadeSpeed;
        easing.type: Easing.OutCubic;
      }
      PropertyAction { target: fadeOverlay; property: "visible"; value: false }
    }
  }
}

