import "root:/";
import "root:/animations" as Anims;
import QtQuick;

MouseArea {
  id: root;
  required property string label;
  property bool icon: false;
  property int labelSize: 0;
  property int iconRotation: 0;

  property color labelColour: Globals.colours.fg;
  property color bg: Globals.colours.bg;
  property color bgHover: Globals.colours.bgHover;
  property color bgPress: Globals.colours.accent;
  property bool invertTextOnPress: true;

  property bool tlRadius: false;
  property bool trRadius: false;
  property bool blRadius: false;
  property bool brRadius: false;
  property bool changeTlRadiusHover: true;
  property bool changeTrRadiusHover: true;
  property bool changeBlRadiusHover: true;
  property bool changeBrRadiusHover: true;

  property bool autoHeight: false;
  property bool autoImplicitHeight: false;
  property bool autoWidth: false;
  property bool autoImplicitWidth: false;
  property int padding: Globals.vars.paddingButton;

  hoverEnabled: true;

  readonly property int autoHeightVal: label.height + padding;
  height: autoHeight ? autoHeightVal : undefined;
  implicitHeight: autoImplicitHeight ? autoHeightVal : undefined;

  readonly property int autoWidthVal: label.width + padding;
  width: autoWidth ? autoWidthVal : undefined;
  implicitWidth: autoImplicitWidth ? autoWidthVal : undefined;

  Rectangle {
    id: background;
    anchors.fill: parent;
    color: root.containsPress
      ? root.bgPress
      : root.containsMouse
        ? root.bgHover
        : root.bg;
    topLeftRadius: root.tlRadius || root.containsMouse && root.changeTlRadiusHover ? Globals.vars.br : 0;
    topRightRadius: root.trRadius || root.containsMouse && root.changeTrRadiusHover ? Globals.vars.br : 0;
    bottomLeftRadius: root.blRadius || root.containsMouse && root.changeBlRadiusHover ? Globals.vars.br : 0;
    bottomRightRadius: root.brRadius || root.containsMouse && root.changeBrRadiusHover ? Globals.vars.br : 0;

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
        pixelSize: root.labelSize > 0 ? root.labelSize : Globals.vars.mainFontSize;
      }
    }

    Icon {
      id: icon;
      visible: root.icon;
      anchors.centerIn: parent;
      icon: root.label;
      color: root.containsPress && root.invertTextOnPress ? root.bg : root.labelColour;
      Anims.ColourTransition on color {}
      size: root.labelSize > 0 ? root.labelSize : parent.height - root.padding * 2;
      rotation: root.iconRotation;
    }
  }
}

