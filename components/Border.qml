import "root:/";
import QtQuick;

Rectangle {
  id: root;

  topLeftRadius: Globals.vars.br;
  topRightRadius: Globals.vars.br;
  bottomLeftRadius: Globals.vars.br;
  bottomRightRadius: Globals.vars.br;
  property bool setParentRadius: false;

  property int borderWidth: Globals.vars.outlineSize;
  property bool leftBorder: true;
  property bool rightBorder: true;
  property bool topBorder: true;
  property bool bottomBorder: true;
  color: Globals.colours.outline;

  z: -1;

  anchors.fill: parent;
  anchors.leftMargin: leftBorder ? -borderWidth : 0;
  anchors.rightMargin: rightBorder ? -borderWidth : 0;
  anchors.topMargin: topBorder ? -borderWidth : 0;
  anchors.bottomMargin: bottomBorder ? -borderWidth : 0;

  function getRadius(radius) {
    const val = radius - borderWidth;
    if (val > 0) return val
    else return 0;
  }

  Component.onCompleted: {
    if (setParentRadius) {
      parent.topLeftRadius     = Qt.binding(() => getRadius(topLeftRadius));
      parent.topRightRadius    = Qt.binding(() => getRadius(topRightRadius));
      parent.bottomLeftRadius  = Qt.binding(() => getRadius(bottomLeftRadius));
      parent.bottomRightRadius = Qt.binding(() => getRadius(bottomRightRadius));
    }
  }
}

