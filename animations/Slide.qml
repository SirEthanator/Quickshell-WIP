import qs
import QtQuick;

ParallelAnimation {
  id: root;
  required property QtObject target;
  property bool reverse: false;
  property int direction: Slide.Direction.Right;
  property int slideOffset: 100;
  property real scaleOffset: 0.9;
  property int duration: Globals.vars.animLen;
  property int originalPos: 0;

  property bool fade: true;
  property bool grow: false;

  enum Direction {
    Right, Left, Up, Down
  }

  NumberAnimation {
    readonly property int fromVal: root.direction === Slide.Direction.Right || root.direction === Slide.Direction.Down ? root.originalPos - root.slideOffset : root.slideOffset + root.originalPos;
    readonly property int toVal: root.originalPos;
    target: root.target;
    property: root.direction === Slide.Direction.Right || root.direction === Slide.Direction.Left ? "x" : "y";
    from: root.reverse ? toVal : fromVal;
    to: root.reverse ? fromVal : toVal;
    easing.type: Easing.OutCubic;
    duration: root.duration;
  }

  NumberAnimation {
    target: root.target;
    property: "opacity";
    from: root.reverse ? 1 : 0;
    to: root.reverse && root.fade ? 0 : 1;
    easing.type: Easing.OutCubic;
    duration: root.fade ? root.duration : 0;
  }

  NumberAnimation {
    target: root.target;
    property: "scale";
    from: root.reverse ? 1 : root.scaleOffset;
    to: root.reverse && root.grow ? root.scaleOffset : 1;
    easing.type: Easing.OutCubic;
    duration: root.grow ? root.duration : 0;
  }
}

