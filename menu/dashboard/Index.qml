import "root:/";
import Quickshell;
import QtQuick;
import QtQuick.Layouts;

Item {
  id: dashboard;

  ColumnLayout {
    anchors.fill: parent;
    spacing: Globals.vars.paddingWindow;

    UserInfo {}

    Rectangle {  //!!! TEMP - Main dashboard content
      color: "slateblue";
      implicitHeight: 450;
      Layout.fillWidth: true;
    }

    Rectangle {  //!!! TEMP - Notification area
      color: "darkslateblue";
      Layout.fillWidth: true;
      Layout.fillHeight: true;
    }
  }
}
