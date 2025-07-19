import qs
import qs.animations as Anims;
import Quickshell;
import Quickshell.Widgets;
import QtQuick;
import QtQuick.Effects;

Item {
  id: root;
  required property string icon;
  property color color: Globals.colours.fg;
  property real size: Globals.vars.moduleIconSize;
  property int rotation;

  property string fallback: "warning-outline-symbolic";
  property bool isMask: true;

  transform: Rotation {
    origin.x: root.size/2; origin.y: root.size/2;
    angle: root.rotation ?? 0;
    Anims.NumberTransition on angle {}
  }

  implicitHeight: size;
  implicitWidth: size;

  IconImage {
    id: image;
    anchors.fill: parent;

    source: Quickshell.iconPath(root.icon, root.fallback);
    visible: !root.isMask;
  }

  MultiEffect {
    id: brightenedIcon;
    anchors.fill: parent;
    source: image;

    brightness: 1;
    visible: false;
  }

  MultiEffect {
    anchors.fill: parent;
    source: brightenedIcon;

    colorization: 1.0;
    colorizationColor: root.color;
    visible: root.isMask;
  }
}
