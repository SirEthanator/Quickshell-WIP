import "root:/";
import "root:/components";
import "root:/animations" as Anims;
import "root:/components";
import Quickshell;
import QtQuick;

PanelWindow {
  id: root;
  color: Globals.conf.menu.dimBackground && Globals.states.menuOpen ? Globals.vars.bgDimmedColour : "transparent";

  Anims.ColourTransition on color {
    duration: Globals.vars.animLen;
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
  implicitHeight: (Globals.conf.bar.floatingModules ? Globals.vars.barHeight - Globals.vars.paddingBar*2 : Globals.vars.barHeight)
    + (Globals.vars.gap * (Globals.conf.bar.docked && Globals.conf.bar.autohide ? 1 : Globals.conf.bar.docked ? 0 : Globals.conf.bar.autohide ? 2 : 1))
    - (!Globals.conf.bar.backgroundOutline || Globals.conf.bar.floatingModules ? Globals.vars.outlineSize*2 : Globals.conf.bar.docked ? Globals.vars.outlineSize : 0);

  // If the bar is autohiding and the always-on-screen part is hovered, the top margin will be 0. The top gap is handled by height and the Rectangle's margins.
  // If autohiding, the gap is subtracted from height to keep a transparent part of the bar on screen so it can be hovered.
  // We then add 1 just to move it a little bit higher to prevent a one pixel tall sliver of the bar showing when it shouldn't.
  margins.top: - ((Globals.conf.bar.autohide && ! hoverArea.containsMouse) || Globals.states.barHidden
    ? root.height - (Globals.conf.bar.autohide ? Globals.vars.gap : 0) + 1
    : 0);

  exclusionMode: Globals.conf.bar.autohide ? ExclusionMode.Ignore : ExclusionMode.Auto;
  exclusiveZone: 0;  // Fixes exclusive zone being way too big

  Behavior on margins.top {
    NumberAnimation {
      duration: Globals.vars.animLen;
      easing.type: Easing.OutExpo;
    }
  }

  MouseArea {  // For autohidden bar to show on hover
    id: hoverArea;
    anchors.fill: parent;
    hoverEnabled: Globals.conf.bar.autohide;

    // Visible background of bar
    Rectangle {
      anchors {
        fill: parent
        // Add a gap if docked without floating modules
        leftMargin: !Globals.conf.bar.docked || (Globals.conf.bar.docked && Globals.conf.bar.floatingModules) ? Globals.vars.gap : 0;
        rightMargin: !Globals.conf.bar.docked || (Globals.conf.bar.docked && Globals.conf.bar.floatingModules) ? Globals.vars.gap : 0;
        // If docked, there should be no top margin.
        topMargin: Globals.conf.bar.docked ? 0 : Globals.vars.gap;
        // If autohiding, there is extra space below for the always-on-screen area that is hovered to show the bar.
        bottomMargin: Globals.conf.bar.autohide ? Globals.vars.gap : 0;
      }
      color: Globals.conf.bar.floatingModules ? "transparent" : Globals.colours.outline;
      radius: Globals.conf.bar.docked ? 0 : Globals.vars.br;

      Rectangle {
        readonly property real marginSize: Globals.conf.bar.backgroundOutline && !Globals.conf.bar.floatingModules ? Globals.vars.outlineSize : 0;
        anchors {
          fill: parent;
          topMargin: Globals.conf.bar.docked ? 0 : marginSize;
          leftMargin: Globals.conf.bar.docked ? 0 : marginSize;
          rightMargin: Globals.conf.bar.docked ? 0 : marginSize;
          bottomMargin: marginSize;
        }
        color: Globals.conf.bar.floatingModules ? "transparent" : Globals.colours.bg;
        radius: parent.radius - Globals.vars.outlineSize;  // inner = outer - padding

        Item {
          id: content;

          // If docked without floating modules, use gap. Also see comment for tb
          readonly property int lrMargins: Globals.conf.bar.floatingModules ? 0 : (Globals.conf.bar.docked && !Globals.conf.bar.floatingModules) ? Globals.vars.gap : Globals.vars.paddingBar;
          // No need for extra margins when modules are floating since the background is invisible.
          readonly property int tbMargins: Globals.conf.bar.floatingModules ? 0 : Globals.vars.paddingBar;
          anchors {
            leftMargin: lrMargins
            rightMargin: lrMargins
            topMargin: tbMargins
            bottomMargin: tbMargins
            fill: parent
          }

          BarSection {
            id: leftModules;
            screen: root.screen;
            window: root;
            modules: Globals.conf.bar.left;
            anchors.left: parent.left;
          }

          BarSection {
            screen: root.screen;
            window: root;
            modules: Globals.conf.bar.centre;
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
            modules: Globals.conf.bar.right;
            anchors.right: parent.right;
          }
        }
      }
    }
  }
}
