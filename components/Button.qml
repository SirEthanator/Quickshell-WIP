import "root:/";
import "root:/animations" as Anims;
import QtQuick;

MouseArea {
  id: root;
  required property string label;
  property bool icon: false;
  property alias bg: background.bg;
  property bool tlRadius: false;
  property bool trRadius: false;
  property bool blRadius: false;
  property bool brRadius: false;

  hoverEnabled: true;

  Rectangle {
    id: background;
    property color bg: Globals.colours.bg;
    anchors.fill: parent;
    color: root.containsPress
      ? Globals.colours.accent
      : root.containsMouse
        ? Globals.colours.bgHover
        : bg;
    topLeftRadius: root.tlRadius || root.containsMouse ? Globals.vars.br : 0;
    topRightRadius: root.trRadius || root.containsMouse ? Globals.vars.br : 0;
    bottomLeftRadius: root.blRadius || root.containsMouse ? Globals.vars.br : 0;
    bottomRightRadius: root.brRadius || root.containsMouse ? Globals.vars.br : 0;

    Anims.NumberTransition on topLeftRadius {}
    Anims.NumberTransition on topRightRadius {}
    Anims.NumberTransition on bottomLeftRadius {}
    Anims.NumberTransition on bottomRightRadius {}

    Anims.ColourTransition on color {}

    Text {
      visible: !root.icon;
      anchors.centerIn: parent;
      text: root.label;
      color: root.containsPress ? root.bg : Globals.colours.fg;
      Anims.ColourTransition on color {}
      font {
        family: Globals.vars.fontFamily;
        pixelSize: Globals.vars.mainFontSize;
      }
    }

    Icon {
      visible: root.icon;
      anchors.centerIn: parent;
      icon: root.label;
      color: root.containsPress ? root.bg : Globals.colours.fg;
      Anims.ColourTransition on color {}
      size: parent.height - Globals.vars.paddingButton * 2;
    }
  }
}

