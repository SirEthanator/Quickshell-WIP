import "root:/";
import "root:/animations" as Anims;
import QtQuick;

MouseArea {
  id: root;

  required property Config page;
  required property string propName;
  property bool checked: page[propName];

  property color fg: Globals.colours.fg;
  property color bg: containsMouse ? Globals.colours.bgHover : Globals.colours.bg;
  property color checkedColour: containsMouse ? Globals.colours.accentLight : Globals.colours.accent;

  width: 40;
  height: 20;

  hoverEnabled: true;

  onClicked: {
    checked = !checked
  }

  onCheckedChanged: {
    page[propName] = checked
  }

  Rectangle {
    id: bg;
    anchors.fill: parent;

    border {
      color: root.checked ? root.checkedColour : root.containsMouse ? root.bg : Globals.colours.outline;
      width: Globals.vars.outlineSize;
      pixelAligned: false;
    }
    radius: height / 2;
    color: root.checked ? root.checkedColour : root.bg;

    Anims.ColourTransition on color {}
    Anims.ColourTransition on border.color {}

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

      Anims.ColourTransition on color {}
      Anims.NumberTransition on x {}
    }
  }
}

