import "root:/";
import "root:/animations" as Anims;
import "root:/utils" as Utils;
import QtQuick;

Item {
  id: root;
  anchors.fill: parent;

  signal hide;
  signal show;

  onHide: opacity = 0;
  onShow: opacity = 1;

  Behavior on opacity {
    Anims.NumberAnim {}
    PropertyAction { target: root; property: "visible"; value: root.opacity === 1 }
  }

  Clock {}
}

