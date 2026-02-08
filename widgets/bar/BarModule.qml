import qs.singletons
import qs.components
import qs.widgets.bar
import qs.animations as Anims;
import QtQuick;
import QtQuick.Layouts;

OutlinedRectangle {
  id: root
  default property alias data: content.data;  // Place children in the RowLayout

  property color background: menu !== null && mouseArea.containsMouse ? Globals.colours.bgHover : Globals.colours.bgLight;
  property string icon;  // If this is an empty string the icon will not be displayed
  property Component customIcon;
  property color iconColour: background;
  property color iconbgColour: Globals.colours.accent;
  property bool forceIconbgColour: false;
  property int padding: Consts.paddingModule; // NOTE: L+R padding only. T+B is based on bar height.
  property bool outline: Conf.bar.moduleOutlines;
  property Tooltip tooltip: null;
  property Tooltip menu: null;

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

  signal clicked(event: MouseEvent);
  signal wheel(event: WheelEvent);

  Anims.ColourTransition on background {}
  Anims.NumberTransition on implicitWidth {}
  clip: true;

  property bool showTooltip: root.tooltip !== null
    && TooltipController?.activeTooltip?.isMenu !== true
    && (mouseArea.containsMouse || (tooltipIsActive && TooltipController.tooltipHovered));

  readonly property bool tooltipIsActive: TooltipController.activeTooltip === root.tooltip;
  readonly property bool menuIsActive: TooltipController.activeTooltip === root.menu;

  Timer {
    id: tooltipShowTimer;
    interval: Conf.bar.tooltipShowDelay;
    repeat: false;
    onTriggered: {
      TooltipController.activeTooltip = root.tooltip;
      TooltipController.activeModule = root;
    }
  }

  Timer {
    id: tooltipHideTimer;
    interval: Conf.bar.tooltipHideDelay;
    repeat: false;
    onTriggered: {
      if (root.tooltipIsActive) {
        TooltipController.clearTooltip();
      }
    }
  }

  onShowTooltipChanged: {
    if (showTooltip) {
      tooltipHideTimer.stop();
      tooltipShowTimer.restart();
    } else {
      tooltipShowTimer.stop();
      tooltipHideTimer.restart();
    }
  }

  MouseArea {
    id: mouseArea;
    anchors.fill: parent.content;

    // Needed when there is a menu for hover colour
    hoverEnabled: root.tooltip !== null || root.menu !== null;

    onClicked: (event) => {
      root.clicked(event);

      if (root.menu === null) return;
      if (root.menuIsActive) {
        TooltipController.clearTooltip();
      } else {
        root.menu.isMenu = true;
        TooltipController.activeTooltip = root.menu;
        TooltipController.activeModule = root;
      }
    }

    onWheel: event => root.wheel(event);

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
  }
}
