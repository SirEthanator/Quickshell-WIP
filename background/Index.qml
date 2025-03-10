import "root:/";
import "widgets" as Widgets;
import Quickshell;
import Quickshell.Wayland;
import QtQuick;

PanelWindow {
  WlrLayershell.layer: WlrLayer.Background;
  exclusionMode: ExclusionMode.Ignore;
  color: Globals.background.bgColour;

  anchors {
    top: true;
    bottom: true;
    left: true;
    right: true;
  }

  MouseArea {
    id: mouseArea;
    anchors.fill: parent;
    hoverEnabled: true;

    // Bar will only be hidden if the background has focus, but widgets will be hidden regardless of whether the background is focused or not

    function mouseMove() {
      cursorHideTimer.restart();
      widgetAndBarHideTimer.restart();
      mouseArea.cursorShape = Qt.ArrowCursor;
      widgets.show();
      Globals.states.barHidden = false;
    }

    onContainsMouseChanged: if (!containsMouse) Globals.states.barHidden = false;

    onMouseXChanged: mouseMove();
    onMouseYChanged: mouseMove();

    Timer {
      id: cursorHideTimer;
      interval: 5000;
      onTriggered: mouseArea.cursorShape = Qt.BlankCursor;
    }

    Timer {
      id: widgetAndBarHideTimer;
      interval: 25_000;
      onTriggered: {
        widgets.hide();
        if (mouseArea.containsMouse) Globals.states.barHidden = true
      }
    }

    Wallpaper {}

    Widgets.Index { id: widgets }
  }
}

