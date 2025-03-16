import "root:/";
import QtQuick.Effects;

MultiEffect {
  required property real padding;

  anchors.fill: parent;
  source: parent;
  autoPaddingEnabled: false;
  paddingRect: Qt.rect(0, 0, padding+width, padding+height);

  shadowEnabled: true;
  shadowColor: Globals.colours.shadow;
  shadowBlur: Globals.vars.shadowBlur;
  shadowOpacity: Globals.vars.shadowOpacity;
}

