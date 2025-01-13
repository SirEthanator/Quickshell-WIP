import "..";  // For Opts
import Quickshell;
import QtQuick;
import QtQuick.Layouts;

Variants {
  model: Quickshell.screens

  PanelWindow {
    id: root;
    property var modelData
    screen: modelData
    color: "transparent"

    anchors {
      top: true
      left: true
      right: true
    }

    // If modules are floating this will add the padding to the height.
    // This is to keep the height the same since the padding is removed from the bar's background.
    height: Opts.bar.floatingModules ? Opts.vars.barHeight - Opts.vars.paddingBar*2 : Opts.vars.barHeight
    margins.top: Opts.bar.docked ? 0 : Opts.vars.gap

    // Visible background of bar
    Rectangle {
      anchors {
        fill: parent
        // Add a gap if docked without floating modules
        leftMargin: ! Opts.bar.docked || (Opts.bar.docked && Opts.bar.floatingModules) ? Opts.vars.gap : 0
        rightMargin: ! Opts.bar.docked || (Opts.bar.docked && Opts.bar.floatingModules) ? Opts.vars.gap : 0
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
