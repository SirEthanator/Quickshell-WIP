pragma ComponentBehavior: Bound;

import qs.singletons
import qs.animations as Anims;
import QtQuick;

ProgressBar {
  id: root;

  signal userChange();

  property bool showScrubber: enableInteractivity;
  property color scrubberColor: Qt.darker(Colors.c.fg, 1.2);
  property color scrubberColorHover: Colors.c.fg;
  property color scrubberColorPress: displayedFg;
  property real scrubberSize: height;

  property bool enableInteractivity: true;
  property bool enableClickToScrub: true;
  property bool enableDragging: true;

  property bool enableScrolling: false;
  property real scrollStep: 0.02;

  readonly property bool dragging: dragLogic.active;

  inset: 5;

  // Default sizes
  implicitHeight: vertical ? 0 : Consts.progressBarHeight + inset * 2;
  implicitWidth: vertical ? Consts.progressBarHeight + inset * 2 : 0;

  function handleWheel(event) {
    if (!root.enableScrolling) return;
    internal.scrollAccum += event.angleDelta.y;

    if (Math.abs(internal.scrollAccum) >= Conf.global.scrollStepSize) {
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
    id: mouse;
    anchors.fill: parent;

    enabled: (root.enableInteractivity && (root.enableClickToScrub || root.enableScrolling)) || root.showScrubber;
    hoverEnabled: root.showScrubber;

    onPressed: (e) => {
      if (!root.enableClickToScrub) return;

      if (root.vertical) {
        root.value = 1 - (e.y / root.height);
      } else {
        root.value = e.x / root.width;
      }

      root.value *= root.maxValue;
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
        root.value -= (delta / root.height) * root.maxValue;
      } else {
        root.value += (delta / root.width) * root.maxValue;
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
      dragThrottleTimer.stop();
      root.value = Math.min(Math.max(root.value, 0), root.maxValue);
      root.userChange();
      root.smoothing = internal.smoothingOriginalVal;
    }
  }

  DragHandler {
    id: dragLogic;
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
    dragThreshold: 0;
  }

  OutlinedRectangle {
    id: scrubber;
    width: root.scrubberSize;
    height: root.scrubberSize;

    outlineSize: 1;

    y: root.fillPosY - height / 2;
    x: root.fillPosX - width / 2;

    color: mouse.containsPress || root.dragging
      ? root.scrubberColorPress
      : mouse.containsMouse
        ? root.scrubberColorHover
        : root.scrubberColor;

    Anims.ColorTransition on color {}

    radius: width / 2;

    visible: root.showScrubber;
  }
}
