import qs.singletons
import QtQuick;

Behavior {
  id: root;
  property int duration: Consts.transitionLenMain;
  ColorAnimation { duration: root.duration; easing.type: Easing.OutCubic }
}

