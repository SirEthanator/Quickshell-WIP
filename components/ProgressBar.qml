import qs.singletons
import qs.animations as Anims;
import QtQuick;

Item {
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

  readonly property real fillPosY: vertical ? height - fill.height : height / 2;
  readonly property real fillPosX: vertical ? width / 2 : fill.width;

  readonly property real warningPosY: vertical ? warningFill.height : height / 2;
  readonly property real warningPosX: vertical ? width / 2 : width - warningFill.width;

  readonly property real dangerPosY: vertical ? percentToLen(maxValue - dangerThreshold) : height / 2;
  readonly property real dangerPosX: vertical ? width / 2 : width - percentToLen(maxValue - dangerThreshold);

  readonly property color displayedFg: clampedValue > dangerThreshold ? fgDanger : clampedValue > warningThreshold ? fgWarning : fg;

  function percentToLen(value: real): real {
    return (root.vertical ? root.height : root.width) * (value / root.maxValue);
  }

  property real barSize: Consts.progressBarHeight;
  property real inset: 0; // if vertical then applies to l+r, else t+b

  property alias radius: bar.radius;
  property alias bottomRightRadius: bar.bottomRightRadius;
  property alias topRightRadius: bar.topRightRadius;
  property alias topLeftRadius: bar.topLeftRadius;
  property alias bottomLeftRadius: bar.bottomLeftRadius;

  Rectangle {
    id: bar;
    radius: 0.5 * height;
    color: root.bg;

    anchors {
      fill: parent;
      topMargin: root.vertical ? 0 : root.inset;
      bottomMargin: root.vertical ? 0 : root.inset;
      leftMargin: root.vertical ? root.inset : 0;
      rightMargin: root.vertical ? root.inset : 0;
    }

    Rectangle {
      id: warningFill;

      anchors.right: parent.right;
      anchors.top: parent.top;

      readonly property real length: root.percentToLen(root.maxValue - root.warningThreshold);
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
      id: fill;

      readonly property real length: root.percentToLen(root.clampedValue);
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

      Anims.NumberTransition on width { enabled: root.smoothing && !root.vertical }
      Anims.NumberTransition on height { enabled: root.smoothing && root.vertical }
      Anims.ColorTransition on color {}
    }
  }
}
