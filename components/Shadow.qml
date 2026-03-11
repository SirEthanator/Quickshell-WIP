import qs.singletons
import QtQuick;
import QtQuick.Effects;

RectangularShadow {
  required property var target;
  anchors.fill: target;
  // Geometric mean * 0.04
  blur: Math.sqrt(target.width * target.height) * 0.04;
  spread: 0;
  color: Colors.c.shadow;
}
