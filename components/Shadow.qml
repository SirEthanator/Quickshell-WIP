import QtQuick;
import QtQuick.Effects;

RectangularShadow {
  required property Item target;
  anchors.fill: target;
  radius: target.radius;
  blur: 20;
  spread: 0;
  color: Qt.darker(target.color, 1.5);
}
