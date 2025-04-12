import "root:/";
import "root:/animations" as Anims;
import QtQuick;

Rectangle { // background
  id: root

  property real value:   0

  property color bg: "black";
  property color fg: "white";

  property string icon: "";  // Only supported if bar is vertical rn
  property bool vertical: false;

  property bool smoothing: true;

  radius: 0.5 * height
  color: bg;

  Rectangle { // foreground
    readonly property int length: root.vertical ? root.height * root.value : root.width * root.value;
    anchors.bottom: parent.bottom;
    anchors.left: parent.left;
    width: !root.vertical ? length : parent.width;
    height: icon.visible ? (root.height - icon.size) * root.value + icon.size : root.vertical ? length : parent.height;
    color: root.fg;
    radius: parent.radius;

    Anims.NumberTransition on width { enabled: root.smoothing }
    Anims.NumberTransition on height { enabled: root.smoothing }

    Icon {
      id: icon;
      visible: root.icon !== "" && root.vertical;
      anchors {
        left: parent.left;
        right: parent.right;
        bottom: parent.bottom;
      }
      icon: root.icon;
      color: root.bg;
      size: parent.width;
    }
  }
}
