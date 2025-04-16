import "root:/";
import "root:/animations" as Anims;
import QtQuick;

MouseArea {
  id: root;
  required property string label;
  property bool icon: false;
  property color labelColour: Globals.colours.fg;
  property color bg: Globals.colours.bg;
  property color bgHover: Globals.colours.bgHover;
  property color bgPress: Globals.colours.accent;
  property bool invertTextOnPress: true;
  property bool tlRadius: false;
  property bool trRadius: false;
  property bool blRadius: false;
  property bool brRadius: false;
  property bool autoHeight: false;
  property int padding: Globals.vars.paddingButton;

  hoverEnabled: true;

  height: autoHeight ? label.height + padding : undefined;

  Rectangle {
    id: background;
    anchors.fill: parent;
    color: root.containsPress
      ? root.bgPress
      : root.containsMouse
        ? root.bgHover 
        : root.bg;
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
      id: label
      visible: !root.icon;
      anchors.centerIn: parent;
      text: root.label;
      color: root.containsPress && root.invertTextOnPress ? root.bg : root.labelColour;
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
      color: root.containsPress && root.invertTextOnPress ? root.bg : root.labelColour;
      Anims.ColourTransition on color {}
      size: parent.height - root.padding * 2;
    }
  }
}

