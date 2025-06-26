import "root:/";
import QtQuick;

ParallelAnimation {
  id: root;
  required property QtObject target;
  property bool reverse: false;
  property string direction: "right";  // TODO: Change to enum
  property int slideOffset: 100;
  property int duration: Globals.vars.animLen;

  NumberAnimation {
    readonly property int fromVal: root.direction === "right" || root.direction === "down" ? -root.slideOffset : root.slideOffset;
    readonly property int toVal: 0;
    target: root.target;
    property: root.direction === "right" || root.direction === "left" ? "x" : "y";
    from: root.reverse ? toVal : fromVal;
    to: root.reverse ? fromVal : toVal;
    easing.type: Easing.OutCubic;
    duration: root.duration;
  }

  NumberAnimation {
    target: root.target;
    property: "opacity";
    from: root.reverse ? 1 : 0;
    to: root.reverse ? 0 : 1;
    easing.type: Easing.OutCubic;
    duration: root.duration;
  }
}

