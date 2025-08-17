import qs
import qs.components
import qs.animations as Anims;
import QtQuick;
import QtQuick.Layouts;

OutlinedRectangle {
  id: root
  default property alias data: content.data;  // Place children in the RowLayout

  property color background: Globals.colours.bgLight;
  property string icon: "";  // If this is an empty string the icon will not be displayed
  property color iconColour: background;
  property color iconbgColour: Globals.colours.accent;
  property bool forceIconbgColour: false;
  property int padding: Globals.vars.paddingModule;
  property bool outline: Globals.conf.bar.moduleOutlines;

  property alias mouseArea: mouseArea;
  property alias hoverEnabled: mouseArea.hoverEnabled;
  property alias containsMouse: mouseArea.containsMouse;
  property alias isPressed: mouseArea.pressed;

  // Used by the loader which the module is wrapped in to determine whether to show or not
  property bool show: true;

  color: root.background;

  disableAllOutlines: !outline;
  topOutline: !(Globals.conf.bar.docked && Globals.conf.bar.floatingModules);

  // If the bar is docked but with floating modules, the top corners' border radius is removed
  topRightRadius: Globals.conf.bar.docked && Globals.conf.bar.floatingModules ? 0 : Globals.vars.br;
  topLeftRadius: Globals.conf.bar.docked && Globals.conf.bar.floatingModules ? 0 : Globals.vars.br;
  bottomLeftRadius: Globals.vars.br;
  bottomRightRadius: Globals.vars.br;

  // Fills the height of the RowLayout which it's inside of. The RowLayout has a margin so this won't stretch to the bar's full height.
  Layout.fillHeight: true;
  // If there is an icon it will include paddingModule for the left, so we only need to add for the right.
  implicitWidth: (!!root.icon ? content.implicitWidth + root.padding : content.implicitWidth + root.padding*2) + (root.outline ? outlineSize*2 : 0);
  // Note that paddingModule doesn't affect top and bottom padding. That is controlled by the bar's height.

  signal clicked(event: MouseEvent);
  signal wheel(event: WheelEvent);

  Anims.ColourTransition on background {}
  Anims.NumberTransition on implicitWidth {}
  clip: true;

  MouseArea {
    id: mouseArea;
    anchors.fill: parent.content;
    RowLayout {
      id: content;
      anchors {
        top: parent.top;
        bottom: parent.bottom;
        left: parent.left;
        leftMargin: !!root.icon ? 0 : root.padding;
      }
      spacing: root.padding;

      Rectangle {
        id: iconbg;
        visible: !!root.icon;  // Visible if icon is a non-empty string.
        color: Globals.conf.bar.multiColourModules || root.forceIconbgColour ? root.iconbgColour : Globals.colours.accent;
        implicitWidth: icon.implicitWidth + root.padding*2;  // This will add padding to both sides of the icon's background.
        Layout.fillHeight: true;
        topLeftRadius: root.content.topLeftRadius;
        bottomLeftRadius: root.content.bottomLeftRadius;

        Icon {
          id: icon;
          anchors.centerIn: parent;

          icon: root.icon;
          color: root.iconColour;
          size: Globals.vars.moduleIconSize;
        }
      }
    }

    onClicked: event => root.clicked(event);
    onWheel: event => root.wheel(event);
  }

}

