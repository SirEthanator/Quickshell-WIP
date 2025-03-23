import "root:/";
import QtQuick;

ParallelAnimation {
  id: root;
  required property QtObject slideTarget;
  required property QtObject fadeTarget;
  property bool reverse: false;
  property string direction: "right";
  property int slideOffset: 100;

  NumberAnimation {
    target: root.slideTarget;
    property: root.direction === "right" ? "margins.left" : "margins.right";
    from: root.reverse ? 0 : -root.slideOffset; to: root.reverse ? -root.slideOffset : 0;
    easing.type: Easing.OutCubic;
    duration: Globals.vars.animLen;
  }

  NumberAnimation {
    target: root.fadeTarget;
    property: "opacity";
    from: root.reverse ? 1 : 0; to: root.reverse ? 0 : 1;
    easing.type: Easing.OutCubic;
    duration: Globals.vars.animLen;
  }
}

