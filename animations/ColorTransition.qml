import qs.singletons
import QtQuick;

Behavior {
  id: root;
  property int duration: Consts.transitionLen;
  ColorAnimation { duration: root.duration; easing.type: Easing.OutCubic }
}

