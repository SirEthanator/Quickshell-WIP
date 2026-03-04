import qs.singletons
import qs.animations as Anims;
import QtQuick;
import QtQuick.Layouts;

MouseArea {
  id: root;
  property string label;
  property string icon;
  property int fontSize;
  property int iconSize;
  property int iconRotation: 0;
  property bool boldFont: false;
  property bool centreLabel: true;

  property bool active: false;

  property color labelColor: Globals.colors.fg;
  property color bg: Globals.colors.bg;
  property color bgHover: Globals.colors.bgHover;
  property color bgPress: Globals.colors.accent;
  property color bgActive: Globals.colors.accent;
  property color bgActiveHover: Globals.colors.accentLight;
  property bool invertTextOnPress: true;

  property int radiusValue: Consts.br;
  property bool allRadius: false;
  property bool tlRadius: false;
  property bool trRadius: false;
  property bool blRadius: false;
  property bool brRadius: false;
  property bool changeRadiusHover: true;
  property bool changeTlRadiusHover: !disabled;
  property bool changeTrRadiusHover: !disabled;
  property bool changeBlRadiusHover: !disabled;
  property bool changeBrRadiusHover: !disabled;

  property int padding: Consts.paddingButton;

  property bool disabled: false;

  hoverEnabled: true;

  implicitHeight: label.implicitHeight + padding*2;
  implicitWidth: label.implicitWidth + padding*2;

  Rectangle {
    id: background;
    anchors.fill: parent;
    color:
      root.disabled ? root.bg
      : root.containsPress ? root.bgPress
        : root.active ? (root.containsMouse ? root.bgActiveHover : root.bgActive)
          : root.containsMouse ? root.bgHover
            : root.bg;

    topLeftRadius: root.tlRadius || root.allRadius || root.containsMouse && root.changeTlRadiusHover ? root.radiusValue : 0;
    topRightRadius: root.trRadius || root.allRadius || root.containsMouse && root.changeTrRadiusHover ? root.radiusValue : 0;
    bottomLeftRadius: root.blRadius || root.allRadius || root.containsMouse && root.changeBlRadiusHover ? root.radiusValue : 0;
    bottomRightRadius: root.brRadius || root.allRadius || root.containsMouse && root.changeBrRadiusHover ? root.radiusValue : 0;

    opacity: root.disabled ? Consts.disabledOpacity : 1;

    Anims.NumberTransition on topLeftRadius {}
    Anims.NumberTransition on topRightRadius {}
    Anims.NumberTransition on bottomLeftRadius {}
    Anims.NumberTransition on bottomRightRadius {}

    Anims.ColorTransition on color {}

    RowLayout {
      id: label;
      spacing: root.padding;
      anchors.verticalCenter: parent.verticalCenter;
      anchors.horizontalCenter: root.centreLabel ? parent.horizontalCenter : undefined;
      anchors.left: !root.centreLabel ? parent.left : undefined;
      anchors.leftMargin: !root.centreLabel ? root.padding : 0;

      width: Math.min(implicitWidth, root.width-root.padding*2)

      readonly property bool changeLabelColor: (root.containsPress || root.active) && root.invertTextOnPress && !root.disabled;

      Icon {
        id: iconLabel;
        visible: !!root.icon;

        icon: root.icon;
        color: parent.changeLabelColor ? root.bg : root.labelColor;
        Anims.ColorTransition on color {}
        size: !!root.iconSize ? root.iconSize : root.height - root.padding * 2;
        rotation: root.iconRotation;
      }

      Text {
        id: textLabel;
        visible: !!root.label;

        Layout.fillWidth: true;
        maximumLineCount: 1;
        elide: Text.ElideRight;

        text: root.label;
        color: parent.changeLabelColor ? root.bg : root.labelColor;
        Anims.ColorTransition on color {}
        font {
          family: Consts.fontFamily;
          pixelSize: !!root.fontSize ? root.fontSize : Consts.mainFontSize;
          bold: root.boldFont;
        }
      }
    }
  }
}

