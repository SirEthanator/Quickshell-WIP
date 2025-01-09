import "..";  // For Opts
import Quickshell;
import QtQuick;
import QtQuick.Layouts;

Variants {
  model: Quickshell.screens

  PanelWindow {
    property var modelData
    screen: modelData
    color: "transparent"

    anchors {
      top: true
      left: true
      right: true
    }

    height: Opts.bar.floatingModules ? Opts.vars.barHeight - Opts.vars.paddingBar*2 : Opts.vars.barHeight
    margins.top: Opts.bar.floating ? Opts.vars.gap : 0

    // Visible background of bar
    Rectangle {
      anchors {
        fill: parent
        leftMargin: Opts.bar.floating ? Opts.vars.gap : 0
        rightMargin: Opts.bar.floating ? Opts.vars.gap : 0
      }
      color: Opts.bar.floatingModules ? "transparent" : Opts.colours.bg
      radius: Opts.bar.floating ? Opts.vars.br : 0

      // =========================
      // ===== CONTENT START =====
      // =========================
      RowLayout {
        anchors {
          leftMargin: Opts.vars.paddingBar
          rightMargin: Opts.vars.paddingBar
          topMargin: Opts.bar.floatingModules ? 0 : Opts.vars.paddingBar
          bottomMargin: Opts.bar.floatingModules ? 0 : Opts.vars.paddingBar
          fill: parent
        }
        uniformCellSizes: true

        RowLayout {
          Layout.fillHeight: true
          Layout.alignment: Qt.AlignLeft

          Text {text: "Placeholder"; color: Opts.colours.fg}
        }

        // ==========

        RowLayout {
          Layout.fillHeight: true
          Layout.alignment: Qt.AlignHCenter

          Clock {}
        }

        // ==========

        RowLayout {
          Layout.fillHeight: true
          Layout.alignment: Qt.AlignRight
          layoutDirection: Qt.RightToLeft

          Text {text: "Placeholder"; color: Opts.colours.fg}
        }
      }
      // =======================
      // ===== CONTENT END =====
      // =======================

    }

  }
}
