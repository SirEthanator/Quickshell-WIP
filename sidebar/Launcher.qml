import "root:/";
import Quickshell;
import QtQuick;
import QtQuick.Layouts;

//!!! Pretty much everything here is temporary

Item {
  id: launcher;

  ColumnLayout {
    width: parent.width;
    // Height should be controlled by content to avoid items being spaced incorrectly
    spacing: 10;

    Repeater {
      model: 20;

      Rectangle {
        color: "darkslateblue";
        implicitHeight: 40;
        Layout.fillWidth: true;
        Layout.alignment: Qt.AlignLeft | Qt.AlignRight | Qt.AlignTop;
      }
    }
  }
}

