import qs
import qs.animations as Anims;
import qs.utils as Utils;
import QtQuick;

Item {
  id: root;
  anchors.fill: parent;

  signal hide;
  signal show;

  onHide: opacity = 0;
  onShow: opacity = 1;

  Behavior on opacity {
    Anims.NumberAnim {}
    PropertyAction { target: root; property: "visible"; value: root.opacity === 1 }
  }

  Loader {
    sourceComponent: Clock {}
    active: Globals.conf.desktop.clockWidget;
    anchors.horizontalCenter: parent.horizontalCenter;
    anchors.verticalCenter: parent.verticalCenter;
    anchors.verticalCenterOffset: Globals.conf.desktop.centreClockWidget ? 0 : -(parent.height/2 - height/2) + Globals.vars.barHeight + Globals.vars.clockWidgetTopMargin;
  }
}

