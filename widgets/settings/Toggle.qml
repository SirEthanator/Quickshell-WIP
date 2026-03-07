import qs.singletons
import qs.widgets.settings // For LSP
import qs.animations as Anims;
import QtQuick;

MouseArea {
  id: root;

  required property string page;
  required property string propName;

  property bool checked: Controller.getVal(page, propName)

  property color fg: Colors.c.fg;
  property color bg: containsMouse ? Colors.c.bgHover : Colors.c.bg;
  property color checkedColor: containsMouse ? Colors.c.accentLight : Colors.c.accent;

  property bool completed: false;
  Component.onCompleted: completed = true;

  width: 40;
  height: 20;

  hoverEnabled: true;

  onClicked: {
    checked = !checked
  }

  onCheckedChanged: {
    if (completed) {
      Controller.changeVal(page, propName, checked);
    }
  }

  Rectangle {
    id: bg;
    anchors.fill: parent;

    border {
      color: root.checked ? root.checkedColor : root.containsMouse ? root.bg : Colors.c.outline;
      width: Consts.outlineSize;
      pixelAligned: false;
    }
    radius: height / 2;
    color: root.checked ? root.checkedColor : root.bg;

    Anims.ColorTransition on color {}
    Anims.ColorTransition on border.color {}

    Rectangle {
      id: knob;

      anchors {
        top: parent.top;
        bottom: parent.bottom;
        margins: 4;
      }
      width: height;
      radius: height / 2;
      color: root.checked ? root.bg : root.fg;

      x: root.checked ? bg.width - width - anchors.margins : anchors.margins;

      Anims.ColorTransition on color {}
      Anims.NumberTransition on x {}
    }
  }
}

