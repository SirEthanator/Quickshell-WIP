import qs.singletons
import qs.animations as Anims;
import QtQuick;

Rectangle {
  id: root

  property real maxValue: 1;
  property real dangerThreshold: maxValue;
  property real warningThreshold: maxValue;

  property real value: 0;
  readonly property real clampedValue: Math.min(Math.max(value, 0), maxValue);

  property color bg: "transparent";
  property color fg: Colors.c.accent;
  property color fgDanger: Colors.c.red;
  property color fgWarning: Colors.c.warning;
  property color warningBg: Colors.c.bgWarning;

  property bool vertical: false;
  property bool smoothing: true;
  property bool roundedFg: true;
  property bool showWarningBackground: true;

  radius: 0.5 * height;
  color: bg;

  readonly property real barPosY: vertical ? height - bar.height : height / 2;
  readonly property real barPosX: vertical ? width / 2 : bar.width;

  readonly property real warningPosY: vertical ? warningBackground.height : height / 2;
  readonly property real warningPosX: vertical ? width / 2 : width - warningBackground.width;

  readonly property real dangerPosY: vertical ? percentageToLength(maxValue - dangerThreshold) : height / 2;
  readonly property real dangerPosX: vertical ? width / 2 : width - percentageToLength(maxValue - dangerThreshold);

  readonly property color displayedFg: clampedValue > dangerThreshold ? fgDanger : clampedValue > warningThreshold ? fgWarning : fg;

  function percentageToLength(value: real): real {
    return (root.vertical ? root.height : root.width) * (value / root.maxValue);
  }

  Rectangle {
    id: warningBackground;

    anchors.right: parent.right;
    anchors.top: parent.top;

    readonly property real length: root.percentageToLength(root.maxValue - root.warningThreshold);
    width: !root.vertical ? length : parent.width;
    height: root.vertical ? length : parent.height;

    function getRadius(parentVal, atEdge) {
      let r;
      if (parentVal === undefined) {
        if (root.radius === undefined) return 0;
        r = root.radius;
      } else {
        r = parentVal;
      }

      if (atEdge || root.roundedFg) {
        return r;
      } else {
        return 0;
      }
    }

    bottomRightRadius: getRadius(root.bottomRightRadius, !root.vertical);
    topRightRadius: getRadius(root.topRightRadius, true);
    topLeftRadius: getRadius(root.topLeftRadius, root.vertical);
    bottomLeftRadius: getRadius(root.bottomLeftRadius, false);

    color: root.warningBg;

    visible: root.showWarningBackground && root.warningThreshold < root.maxValue;
  }

  Rectangle {
    id: bar;

    readonly property real length: root.percentageToLength(root.clampedValue);
    anchors.bottom: parent.bottom;
    anchors.left: parent.left;

    width: !root.vertical ? length : parent.width;
    height: root.vertical ? length : parent.height;

    color: root.displayedFg;

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
    Anims.ColorTransition on color {}
  }
}
