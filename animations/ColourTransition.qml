import qs
import QtQuick;

Behavior {
  id: root;
  property int duration: Globals.vars.transitionLen;
  ColorAnimation { duration: root.duration; easing.type: Easing.OutCubic }
}

