import qs.singletons
import qs.components
import qs.animations as Anims;
import QtQuick;
import QtQuick.Layouts;

OutlinedRectangle {
  id: root
  default property alias data: content.data;  // Place children in the RowLayout

  property color background: Globals.colours.bgLight;
  property string icon;  // If this is an empty string the icon will not be displayed
  property Component customIcon;
  property color iconColour: background;
  property color iconbgColour: Globals.colours.accent;
  property bool forceIconbgColour: false;
  property int padding: Consts.paddingModule;
  property bool outline: Conf.bar.moduleOutlines;

  property alias mouseArea: mouseArea;
  property alias hoverEnabled: mouseArea.hoverEnabled;
  property alias containsMouse: mouseArea.containsMouse;
  property alias isPressed: mouseArea.pressed;

  // Used by the loader which the module is wrapped in to determine whether to show or not
  property bool show: true;

  color: root.background;

  disableAllOutlines: !outline;
  topOutline: !(Conf.bar.docked && Conf.bar.floatingModules);

  // If the bar is docked but with floating modules, the top corners' border radius is removed
  topRightRadius: Conf.bar.docked && Conf.bar.floatingModules ? 0 : Consts.br;
  topLeftRadius: Conf.bar.docked && Conf.bar.floatingModules ? 0 : Consts.br;
  bottomLeftRadius: Consts.br;
  bottomRightRadius: Consts.br;

  // Fills the height of the RowLayout which it's inside of. The RowLayout has a margin so this won't stretch to the bar's full height.
  Layout.fillHeight: true;
  // If there is an icon it will include paddingModule for the left, so we only need to add for the right.
  implicitWidth: (root.icon || root.customIcon ? content.implicitWidth + root.padding : content.implicitWidth + root.padding*2) + (root.outline ? outlineSize*2 : 0);
  // WARN: Don't remove 'root.' from the above property, it causes issues

  // NOTE: paddingModule doesn't affect top and bottom padding. That is controlled by the bar's height.

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
        leftMargin: root.icon || root.customIcon ? 0 : root.padding;
      }
      spacing: root.padding;

      Rectangle {
        id: iconbg;
        visible: !!root.icon || !!root.customIcon;  // Visible if icon is a non-empty string.
        color: Conf.bar.multiColourModules || root.forceIconbgColour ? root.iconbgColour : Globals.colours.accent;
        implicitWidth: Consts.moduleIconSize + root.padding*2;  // This will add padding to both sides of the icon's background.
        Layout.fillHeight: true;
        topLeftRadius: root.content.topLeftRadius;
        bottomLeftRadius: root.content.bottomLeftRadius;

        Loader {
          id: customIconLoader;
          sourceComponent: root.customIcon;
          active: root.customIcon;
          anchors.centerIn: parent;
          width: Consts.moduleIconSize;
          height: width;
        }

        Icon {
          id: icon;
          anchors.centerIn: parent;
          visible: !root.customIcon;

          icon: root.icon;
          color: root.iconColour;
          size: Consts.moduleIconSize;
        }
      }
    }

    onClicked: event => root.clicked(event);
    onWheel: event => root.wheel(event);
  }

}

