import qs.singletons
import qs.animations as Anims;
import QtQuick;

Rectangle {
  id: root

  property real value: 0;
  readonly property real clampedValue: Math.min(Math.max(value, 0), 1);

  property color bg: "transparent";
  property color fg: Globals.colours.accent;

  property bool vertical: false;
  property bool smoothing: true;
  property bool roundedFg: true;

  radius: 0.5 * height;
  color: bg;

  readonly property real barPosY: vertical ? height - bar.height : height / 2;
  readonly property real barPosX: vertical ? width / 2 : bar.width;

  Rectangle {
    id: bar;

    readonly property int length: (root.vertical ? root.height : root.width) * root.clampedValue;
    anchors.bottom: parent.bottom;
    anchors.left: parent.left;

    width: !root.vertical ? length : parent.width;
    height: root.vertical ? length : parent.height;

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
  }
}
