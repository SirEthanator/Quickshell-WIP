import "..";  // For Globals
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

    height: Globals.vars.barHeight
    margins.top: Globals.vars.gap

    // Visible background of bar
    Rectangle {
      anchors {
        fill: parent
        leftMargin: Globals.vars.gap
        rightMargin: Globals.vars.gap
      }
      color: Globals.colours.bg
      radius: Globals.vars.br

      // =========================
      // ===== CONTENT START =====
      // =========================
      RowLayout {
        anchors {
          margins: Globals.vars.paddingBar
          fill: parent
        }
        uniformCellSizes: true

        RowLayout {
          Layout.fillHeight: true
          Layout.alignment: Qt.AlignLeft

          Text {text: "Placeholder"; color: Globals.colours.fg}
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

          Text {text: "Placeholder"; color: Globals.colours.fg}
        }
      }
      // =======================
      // ===== CONTENT END =====
      // =======================

    }

  }
}
