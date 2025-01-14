import "..";  // For Opts
import Quickshell;
import Quickshell.Wayland;
import QtQuick;
import QtQuick.Layouts;

Variants {
  model: Quickshell.screens

  PanelWindow {
    id: root;
    required property var modelData;
    screen: modelData;
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
    height: (Opts.bar.floatingModules ? Opts.vars.barHeight - Opts.vars.paddingBar*2 : Opts.vars.barHeight)
      + Opts.vars.gap * (Opts.bar.docked && Opts.bar.autohide ? 1 : Opts.bar.docked ? 0 : Opts.bar.autohide ? 2 : 1);

    // If the bar is autohiding and the always-on-screen part is hovered, the top margin will be 0. The top gap is handled by height and the Rectangle's margins.
    // The gap is subtracted from height to keep a transparent part of the bar on screen so it can be hovered.
    // We then add 1 just to move it a little bit higher to prevent one or two pixels of the bar from showing while they should be hidden.
    margins.top: - (Opts.bar.autohide && ! hoverArea.containsMouse ? root.height - Opts.vars.gap + 1 : 0);

    exclusionMode: Opts.bar.autohide ? ExclusionMode.Ignore : ExclusionMode.Auto;

    MouseArea {  // For autohidden bar to show on hover
      id: hoverArea;
      anchors.fill: parent;
      hoverEnabled: true;

      // Visible background of bar
      Rectangle {
        anchors {
          fill: parent
          // Add a gap if docked without floating modules
          leftMargin: ! Opts.bar.docked || (Opts.bar.docked && Opts.bar.floatingModules) ? Opts.vars.gap : 0
          rightMargin: ! Opts.bar.docked || (Opts.bar.docked && Opts.bar.floatingModules) ? Opts.vars.gap : 0
          // If docked, there should be no top margin.
          topMargin: Opts.bar.docked ? 0 : Opts.vars.gap;
          // If autohiding, there is extra space below for the always-on-screen area that is hovered to show the bar.
          bottomMargin: Opts.bar.autohide ? Opts.vars.gap : 0;
        }
        color: Opts.bar.floatingModules ? "transparent" : Opts.colours.bg
        radius: Opts.bar.docked ? 0 : Opts.vars.br

        // =========================
        // ===== CONTENT START =====
        // =========================
        Item {
          id: content;

          // If docked without floating modules, use gap. Also see comment for tb
          readonly property int lrMargins: Opts.bar.floatingModules ? 0 : (Opts.bar.docked && ! Opts.bar.floatingModules) ? Opts.vars.gap : Opts.vars.paddingBar;
          // No need for extra margins when modules are floating since the background is invisible.
          readonly property int tbMargins: Opts.bar.floatingModules ? 0 : Opts.vars.paddingBar;
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
            spacing: Opts.vars.marginModule;

            LauncherButton {}
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
            spacing: Opts.vars.marginModule;

            DateAndTime {}
          }

          // ==========

          RowLayout {
            anchors {
              bottom: parent.bottom
              top: parent.top
              right: parent.right
            }
            spacing: Opts.vars.marginModule;
            layoutDirection: Qt.RightToLeft

            Volume {}
          }
        }
        // =======================
        // ===== CONTENT END =====
        // =======================

      }
    }

  }
}
