import "root:/"
import QtQuick;

NumberAnimation {
  required property int offset;
  property bool exit: false;
  property: "y";
  from: exit ? 0 : -offset;
  to: exit ? offset : 0;
  duration: Globals.vars.animLen;
  easing.type: Easing.OutCubic;
}

