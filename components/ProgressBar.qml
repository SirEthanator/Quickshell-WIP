import qs.singletons
import qs.animations as Anims;
import QtQuick;

Rectangle {
  id: root

  property real value: 0;
  readonly property real clampedValue: Math.min(Math.max(value, 0), 1);

  property color bg: "transparent";
  property color fg: Globals.colours.accent;

  property string icon: "";  // Only supported if bar is vertical
  property bool vertical: false;
  property bool smoothing: true;
  property bool roundedFg: true;

  radius: 0.5 * height;
  color: bg;

  readonly property real barPosY: vertical ? bar.height : bar.height / 2;
  readonly property real barPosX: vertical ? bar.width / 2 : bar.width;

  Rectangle {
    id: bar;

    readonly property int length: (root.vertical ? root.height : root.width) * root.clampedValue;
    anchors.bottom: parent.bottom;
    anchors.left: parent.left;

    width: !root.vertical ? length : parent.width;
    height: icon.visible
      ? (root.height - icon.size) * root.clampedValue + icon.size
      : root.vertical
        ? length
        : parent.height;

    color: root.fg;

    function getRadius(parentVal, edgeDistance) {
      let r;
      if (parentVal === undefined) {
        if (root.radius === undefined) return 0;
        r = root.radius;
      } else {
        r = parentVal;
      }

      if (!root.roundedFg) {
        return Math.max(0, r - edgeDistance);
      } else {
        return r;
      }
    }

    readonly property int lDistance: 0;
    readonly property int rDistance: root.vertical ? root.height - height : root.width - width;

    topLeftRadius: getRadius(root.topLeftRadius, lDistance);
    topRightRadius: getRadius(root.topRightRadius, rDistance);
    bottomLeftRadius: getRadius(root.bottomLeftRadius, lDistance);
    bottomRightRadius: getRadius(root.bottomRightRadius, rDistance);

    Anims.NumberTransition on width { enabled: root.smoothing }
    Anims.NumberTransition on height { enabled: root.smoothing }
    Anims.ColourTransition on color {}

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
