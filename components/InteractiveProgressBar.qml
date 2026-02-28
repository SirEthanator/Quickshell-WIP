pragma ComponentBehavior: Bound;

import qs.singletons
import QtQuick;

ProgressBar {
  id: root;

  signal userChange();

  property bool showScrubber: enableInteractivity;
  property color scrubberColor: Qt.darker(Globals.colours.fg, 1.2);
  property color scrubberColorHover: Globals.colours.fg;
  property color scrubberColorPress: Globals.colours.accent;
  property real scrubberSize: (root.vertical ? root.width : root.height) * 2 + scrubber.outlineSize + 2;

  property bool enableInteractivity: true;
  property bool enableClickToScrub: true;
  property bool enableDragging: true;

  property bool enableScrolling: false;
  property real scrollStep: 0.02;

  readonly property bool dragging: barDragLogic.active || scrubberDragLogic.active;

  function handleWheel(event) {
    if (!root.enableScrolling) return;
    internal.scrollAccum += event.angleDelta.y;

    if (internal.scrollAccum >= Conf.global.scrollStepSize || internal.scrollAccum <= -Conf.global.scrollStepSize) {
      root.value += root.scrollStep * Math.sign(internal.scrollAccum);
      root.userChange();
      internal.scrollAccum = 0;
    }
  }

  QtObject {
    id: internal;

    property bool smoothingOriginalVal;
    property real scrollAccum: 0;
  }

  MouseArea {
    anchors.fill: parent;

    enabled: root.enableInteractivity && (root.enableClickToScrub || root.enableScrolling);

    onPressed: (e) => {
      if (!root.enableClickToScrub) return;

      if (root.vertical) {
        root.value = 1 - (e.y / root.height);
      } else {
        root.value = e.x / root.width;
      }
    }

    // Will not fire if a drag starts
    onReleased: {
      if (!root.enableClickToScrub) return;
      root.userChange();
    }

    onWheel: (event) => {
      root.handleWheel(event);
    }
  }

  Timer {
    id: dragThrottleTimer;
    property real delta: 0;

    interval: 12;
    repeat: false;
    onTriggered: {
      if (root.vertical) {
        root.value -= (delta / root.height);
      } else {
        root.value += delta / root.width;
      }
      delta = 0;
    }
  }

  function handleDrag(delta) {
    dragThrottleTimer.delta += delta;
    if (!dragThrottleTimer.running) {
      dragThrottleTimer.start();
    }
  }

  function handleDragActiveChanged(active) {
    if (active) {
      internal.smoothingOriginalVal = root.smoothing;
      root.smoothing = false;
    } else {
      root.value = Math.min(Math.max(root.value, 0), 1);
      root.userChange();
      root.smoothing = internal.smoothingOriginalVal;
    }
  }

  component DragLogic : DragHandler {
    acceptedButtons: Qt.LeftButton;
    target: null;

    enabled: root.enableInteractivity && root.enableDragging;

    xAxis {
      enabled: !root.vertical;
      onActiveValueChanged: (delta) => root.handleDrag(delta);
    }
    yAxis {
      enabled: root.vertical;
      onActiveValueChanged: (delta) => root.handleDrag(delta);
    }

    onActiveChanged: root.handleDragActiveChanged(active);
  }

  DragLogic {
    id: barDragLogic;
    dragThreshold: 6;
  }

  OutlinedRectangle {
    id: scrubber;
    width: root.scrubberSize;
    height: root.scrubberSize;

    outlineSize: 1;

    y: root.barPosY - height / 2;
    x: root.barPosX - width / 2;

    color: scrubberMouse.containsPress || root.dragging
      ? root.scrubberColorPress
      : scrubberMouse.containsMouse
        ? root.scrubberColorHover
        : root.scrubberColor;

    radius: width / 2;

    visible: root.showScrubber;

    MouseArea {
      id: scrubberMouse;
      anchors.fill: parent;
      hoverEnabled: true;

      onWheel: (event) => {
        root.handleWheel(event);
      }
    }

    DragLogic {
      id: scrubberDragLogic;
      dragThreshold: 0;
    }
  }
}
