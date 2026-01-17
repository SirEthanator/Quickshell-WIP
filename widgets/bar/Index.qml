pragma ComponentBehavior: Bound

import qs.singletons
import qs.components
import qs.widgets.sidebar as Sidebar;
import qs.animations as Anims;
import Quickshell;
import Quickshell.Wayland;
import QtQuick;

PanelWindow {
  id: root;
  readonly property bool bgIsDimmed:
    // If the menu's background is configured to be dimmed and the menu is open, we want to dim behind the bar too
    // However, if autohide is enabled, we don't need to do this
    (Conf.menu.dimBackground && Sidebar.Controller.sidebarOpen && !Conf.bar.autohide);

  color: bgIsDimmed ? Consts.bgDimmedColour : "transparent";

  Anims.ColourTransition on color {
    duration: Consts.animLen;
  }

  anchors {
    top: true;
    left: true;
    right: true;
  }

  // If modules are floating this will remove the padding from the height.
  // This is to keep the modules' height the same since the padding is removed from the bar's background.
  // Then we add the gap. If it's docked we don't need a gap, so we multiply by 0, but if it's not we need the top gap.
  // If the bar is autohiding, we also need the bottom gap for the hover area. It will not reserve extra space as the exclusivity will be set to ignore.
  // If the outline is disabled, it is subtracted from the height. If the bar is docked and the outline is on, only the top outline must be subtracted.
  implicitHeight: (Conf.bar.floatingModules ? Consts.barHeight - Consts.paddingBar*2 : Consts.barHeight)
    + (Consts.gap * (Conf.bar.docked && Conf.bar.autohide ? 1 : Conf.bar.docked ? 0 : Conf.bar.autohide ? 2 : 1))
    - (!Conf.bar.backgroundOutline || Conf.bar.floatingModules ? Consts.outlineSize*2 : Conf.bar.docked ? Consts.outlineSize : 0);

  // If the bar is autohiding and the always-on-screen part is hovered, the top margin will be 0. The top gap is handled by height and the Rectangle's margins.
  // If autohiding, the gap is subtracted from height to keep a transparent part of the bar on screen so it can be hovered.
  // We then add 1 just to move it a little bit higher to prevent a one pixel tall sliver of the bar showing when it shouldn't.
  margins.top: - ((Conf.bar.autohide && !hoverArea.containsMouse) || Globals.states.barHidden
    ? root.height - (Conf.bar.autohide ? Consts.gap : 0) + 1
    : 0);

  exclusionMode: Conf.bar.autohide ? ExclusionMode.Ignore : ExclusionMode.Auto;

  // Shows bar over fullscreen applications if the menu is open. This has no effect with autohide.
  WlrLayershell.layer: Sidebar.Controller.sidebarOpen ? WlrLayer.Overlay : WlrLayer.Top;

  Behavior on margins.top {
    NumberAnimation {
      property: "margins.top";
      duration: Consts.animLen;
      easing.type: Easing.OutExpo;
    }
  }

  MouseArea {  // For autohidden bar to show on hover
    id: hoverArea;
    anchors.fill: parent;
    hoverEnabled: Conf.bar.autohide;

    // Visible background of bar
    OutlinedRectangle {
      id: background;
      anchors {
        fill: parent
        // Add a gap if docked without floating modules
        leftMargin: !Conf.bar.docked || (Conf.bar.docked && Conf.bar.floatingModules) ? Consts.gap : 0;
        rightMargin: !Conf.bar.docked || (Conf.bar.docked && Conf.bar.floatingModules) ? Consts.gap : 0;
        // If docked, there should be no top margin.
        topMargin: Conf.bar.docked ? 0 : Consts.gap;
        // If autohiding, there is extra space below for the always-on-screen area that is hovered to show the bar.
        bottomMargin: Conf.bar.autohide ? Consts.gap : 0;
      }

      color: Conf.bar.floatingModules ? "transparent" : Globals.colours.bg;
      radius: Conf.bar.docked ? 0 : Consts.br;

      readonly property bool outlines: Conf.bar.backgroundOutline && !Conf.bar.floatingModules;
      topOutline: outlines && !Conf.bar.docked;
      leftOutline: outlines && !Conf.bar.docked;
      rightOutline: outlines && !Conf.bar.docked;
      bottomOutline: outlines;

      Item {
        id: content;

        // If docked without floating modules, use gap. Also see comment for tb
        readonly property int lrMargins: Conf.bar.floatingModules ? 0 : (Conf.bar.docked && !Conf.bar.floatingModules) ? Consts.gap : Consts.paddingBar;
        // No need for extra margins when modules are floating since the background is invisible.
        readonly property int tbMargins: Conf.bar.floatingModules ? 0 : Consts.paddingBar;
        anchors {
          leftMargin: lrMargins
          rightMargin: lrMargins
          topMargin: tbMargins
          bottomMargin: tbMargins
          fill: parent.content;
        }

        BarSection {
          id: leftModules;
          screen: root.screen;
          window: root;
          modules: Conf.bar.left;
          anchors.left: parent.left;
        }

        BarSection {
          screen: root.screen;
          window: root;
          modules: Conf.bar.centre;
          anchors.horizontalCenter: parent.horizontalCenter;
          anchors.horizontalCenterOffset: {
            const contentCenter = content.width / 2
            const leftModulesEdge = leftModules.x + leftModules.width + spacing;
            const rightModulesEdge = rightModules.x - spacing;
            const centerModulesMidPoint = width / 2;

            // Check if centering would cause overlap with left
            if (contentCenter - centerModulesMidPoint < leftModulesEdge) {
              return leftModulesEdge + centerModulesMidPoint - contentCenter
            }
            // Check if centering would cause overlap with right
            if (contentCenter + centerModulesMidPoint > rightModulesEdge) {
              return rightModulesEdge - centerModulesMidPoint - contentCenter
            }
            // No overlap, stay at center of content
            return 0
          }
        }

        BarSection {
          id: rightModules;
          screen: root.screen;
          window: root;
          modules: Conf.bar.right;
          anchors.right: parent.right;
        }
      }
    }
  }
}
