import "animations" as Anims;
import QtQuick;

Rectangle { // background
  id: root

  property real value:   0

  property color bg: "black";
  property color fg: "white";

  border.width: 0.05 * root.height
  radius: 0.5 * height
  color: bg;

  Rectangle { // foreground
    x: 0;  y: 0;
    width: root.width * root.value;
    height: root.height;
    color: root.fg;
    radius: parent.radius;

    Anims.NumberTransition on width {}
  }
}
