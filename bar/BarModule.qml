import "root:/";
import Quickshell;
import QtQuick;
import QtQuick.Layouts;
import org.kde.kirigami as Kirigami;

Rectangle {
  id: root
  default property alias data: content.data;  // Place children in the RowLayout

  property color background: Globals.colours.bgLight;
  property string icon: "";  // If this is an empty string the icon will not be displayed
  property color iconColour: Globals.colours.bgLight;
  property color iconbgColour: Globals.colours.accent;

  property alias mouseArea: mouseArea;
  property alias hoverEnabled: mouseArea.hoverEnabled;
  property alias containsMouse: mouseArea.containsMouse;
  property alias isPressed: mouseArea.pressed;

  color: root.background;
  // If the bar is docked but with floating modules, the top corners' border radius is removed
  topRightRadius: Globals.bar.docked && Globals.bar.floatingModules ? 0 : Globals.vars.br;
  topLeftRadius: Globals.bar.docked && Globals.bar.floatingModules ? 0 : Globals.vars.br;
  bottomLeftRadius: Globals.vars.br;
  bottomRightRadius: Globals.vars.br;

  // Fills the height of the RowLayout which it's inside of. The RowLayout has a margin so this won't stretch to the bar's full height.
  Layout.fillHeight: true;
  // If there is an icon it will include paddingModule for the left, so we only need to add for the right.
  implicitWidth: root.icon ? content.implicitWidth + Globals.vars.paddingModule : content.implicitWidth + Globals.vars.paddingModule*2
  // Note that paddingModule doesn't affect top and bottom padding. That is controlled by the bar's height.

  signal clicked(event: MouseEvent);
  //signal entered();
  //signal exited();
  //signal pressed(event: MouseEvent);
  //signal released(event: MouseEvent);
  signal wheel(event: WheelEvent);

  Behavior on background {
    ColorAnimation { duration: 250; easing.type: Easing.OutCubic }
  }


  MouseArea {
    id: mouseArea;
    anchors.fill: parent;

    RowLayout {
      id: content;
      anchors.top: parent.top;
      anchors.bottom: parent.bottom;
      anchors.left: parent.left;
      anchors.leftMargin: root.icon ? 0 : Globals.vars.paddingModule;
      spacing: Globals.vars.paddingModule;

      Rectangle {
        id: iconbg;
        visible: !!root.icon;  // Visible if icon is a non-empty string.
        color: Globals.bar.multiColourModules ? root.iconbgColour : Globals.colours.accent;
        implicitWidth: icon.implicitWidth + Globals.vars.paddingModule*2;  // This will add padding to both sides of the icon's background.
        Layout.fillHeight: true;
        topLeftRadius: Globals.bar.docked && Globals.bar.floatingModules ? 0 : Globals.vars.br;  // See comment on root's br
        bottomLeftRadius: Globals.vars.br;

        Kirigami.Icon {
          id: icon;
          anchors.centerIn: parent;

          source: root.icon;
          fallback: "error-symbolic";
          isMask: true;  // Allows us to change the icon's colour. It replaces all non-transparent colours with ours.
          color: root.iconColour;
          roundToIconSize: false;  // Improves scaling for non-standard icon sizes
          implicitWidth: Globals.vars.moduleIconSize;
          implicitHeight: Globals.vars.moduleIconSize;
        }
      }
    }

    onClicked: event => root.clicked(event);
    onWheel: event => root.wheel(event);
  }

}

