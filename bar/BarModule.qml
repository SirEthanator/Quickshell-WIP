import "..";
import Quickshell;
import QtQuick;
import QtQuick.Layouts;
import org.kde.kirigami as Kirigami;

Rectangle {
  id: root
  default property alias data: content.data;  // Place children in the RowLayout

  property string icon: "";  // If this is an empty string the icon will not be displayed
  property color iconColour: Opts.colours.bgLight

  color: Opts.colours.bgLight;
  // If the bar is docked but with floating modules, the top corners' border radius is removed
  topRightRadius: ! Opts.bar.floating && Opts.bar.floatingModules ? 0 : Opts.vars.br;
  topLeftRadius: ! Opts.bar.floating && Opts.bar.floatingModules ? 0 : Opts.vars.br;
  bottomLeftRadius: Opts.vars.br;
  bottomRightRadius: Opts.vars.br;

  // Fills the height of the RowLayout which it's inside of. The RowLayout has a margin so this won't stretch to the bar's full height.
  Layout.fillHeight: true;
  // If there is an icon it will include paddingModule for the left, so we only need to add for the right.
  implicitWidth: root.icon ? content.implicitWidth + Opts.vars.paddingModule : content.implicitWidth + Opts.vars.paddingModule*2
  // Note that paddingModule doesn't affect top and bottom padding. That is controlled by the bar's height.

  RowLayout {
    id: content;
    anchors.top: parent.top;
    anchors.bottom: parent.bottom;
    anchors.left: parent.left;
    anchors.leftMargin: root.icon ? 0 : Opts.vars.paddingModule;
    spacing: Opts.vars.paddingModule;

    Rectangle {
      id: iconbg;
      visible: !!root.icon;  // Visible if icon is a non-empty string.
      color: Opts.colours.accent;
      implicitWidth: icon.implicitWidth + Opts.vars.paddingModule*2;  // This will add padding to both sides of the icon's background.
      Layout.fillHeight: true;
      topLeftRadius: ! Opts.bar.floating && Opts.bar.floatingModules ? 0 : Opts.vars.br;  // See comment on root's br
      bottomLeftRadius: Opts.vars.br;

      Kirigami.Icon {
        id: icon;
        anchors.centerIn: parent;

        source: root.icon;
        fallback: "error-symbolic";
        isMask: true;  // Allows us to change the icon's colour. It replaces all non-transparent colours with ours.
        color: root.iconColour;
        roundToIconSize: false;  // Improves scaling for non-standard icon sizes
        implicitWidth: Opts.vars.moduleIconSize;
        implicitHeight: Opts.vars.moduleIconSize;
      }
    }
  }
}

