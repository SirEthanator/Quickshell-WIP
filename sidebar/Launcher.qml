import "root:/";
import Quickshell;
import QtQuick;
import QtQuick.Layouts;

Item {  //!!! TEMP = Will be moved to separate file
  id: launcher;

  ColumnLayout {
    width: parent.width;
    spacing: 5;

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

