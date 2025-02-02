import "root:/";  // For Globals
import Quickshell;
import Quickshell.Wayland;
import QtQuick;
import QtQuick.Layouts;

PanelWindow {
  id: root;
  color: "transparent";

  anchors {
    top: true;
    left: true;
    right: true;
  }

  // If modules are floating this will remove the padding from the height.
  // This is to keep the modules' height the same since the padding is removed from the bar's background.
  // Then we add the gap. If it's docked we don't need a gap, so we multiply by 0, but if it's not we need the top gap.
  // If the bar is autohiding, we also need the bottom gap for the hover area. It will not reserve extra space as the exclusivity will be set to ignore
  height: (Globals.bar.floatingModules ? Globals.vars.barHeight - Globals.vars.paddingBar*2 : Globals.vars.barHeight)
    + Globals.vars.gap * (Globals.bar.docked && Globals.bar.autohide ? 1 : Globals.bar.docked ? 0 : Globals.bar.autohide ? 2 : 1);

  // If the bar is autohiding and the always-on-screen part is hovered, the top margin will be 0. The top gap is handled by height and the Rectangle's margins.
  // The gap is subtracted from height to keep a transparent part of the bar on screen so it can be hovered.
  // We then add 1 just to move it a little bit higher to prevent one or two pixels of the bar from showing while they should be hidden.
  margins.top: - (Globals.bar.autohide && ! hoverArea.containsMouse ? root.height - Globals.vars.gap + 1 : 0);

  exclusionMode: Globals.bar.autohide ? ExclusionMode.Ignore : ExclusionMode.Auto;

  Behavior on margins.top {
    NumberAnimation {
      duration: Globals.vars.animLen;
      easing.type: Easing.OutExpo;
    }
  }

  MouseArea {  // For autohidden bar to show on hover
    id: hoverArea;
    anchors.fill: parent;
    hoverEnabled: true;

    // Visible background of bar
    Rectangle {
      anchors {
        fill: parent
        // Add a gap if docked without floating modules
        leftMargin: ! Globals.bar.docked || (Globals.bar.docked && Globals.bar.floatingModules) ? Globals.vars.gap : 0
        rightMargin: ! Globals.bar.docked || (Globals.bar.docked && Globals.bar.floatingModules) ? Globals.vars.gap : 0
        // If docked, there should be no top margin.
        topMargin: Globals.bar.docked ? 0 : Globals.vars.gap;
        // If autohiding, there is extra space below for the always-on-screen area that is hovered to show the bar.
        bottomMargin: Globals.bar.autohide ? Globals.vars.gap : 0;
      }
      color: Globals.bar.floatingModules ? "transparent" : Globals.colours.bg
      radius: Globals.bar.docked ? 0 : Globals.vars.br

      // =========================
      // ===== CONTENT START =====
      // =========================
      Item {
        id: content;

        // If docked without floating modules, use gap. Also see comment for tb
        readonly property int lrMargins: Globals.bar.floatingModules ? 0 : (Globals.bar.docked && ! Globals.bar.floatingModules) ? Globals.vars.gap : Globals.vars.paddingBar;
        // No need for extra margins when modules are floating since the background is invisible.
        readonly property int tbMargins: Globals.bar.floatingModules ? 0 : Globals.vars.paddingBar;
        anchors {
          leftMargin: content.lrMargins
          rightMargin: content.lrMargins
          topMargin: content.tbMargins
          bottomMargin: content.tbMargins
          fill: parent
        }

        RowLayout {
          anchors {
            bottom: parent.bottom
            top: parent.top
            left: parent.left
          }
          spacing: Globals.vars.marginModule;

          SidebarBtn {}
          Workspaces {screen: root.screen}
          ActiveWindow {}
        }

        // ==========

        RowLayout {
          anchors {
            bottom: parent.bottom
            top: parent.top
            horizontalCenter: parent.horizontalCenter
          }
          spacing: Globals.vars.marginModule;

          DateAndTime {}
        }

        // ==========

        RowLayout {
          anchors {
            bottom: parent.bottom
            top: parent.top
            right: parent.right
          }
          spacing: Globals.vars.marginModule;

          // SysTray {window: root}
          Volume {}
        }
      }
      // =======================
      // ===== CONTENT END =====
      // =======================

    }
  }

}
