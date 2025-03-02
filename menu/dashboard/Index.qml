import "root:/";
import Quickshell;
import QtQuick;
import QtQuick.Layouts;
import "sysstats" as SysStats;

Item {
  id: dashboard;
  required property var shellroot;
  required property var screen;

  ColumnLayout {
    anchors.fill: parent;
    spacing: Globals.vars.paddingWindow;

    UserInfo { shellroot: dashboard.shellroot; screen: dashboard.screen }

    // Rectangle {  //!!! TEMP - Main dashboard content
    //   color: "slateblue";
    //   implicitHeight: 450;
    //   Layout.fillWidth: true;
    // }

    SysStats.CPU {}
    SysStats.Memory {}

    Rectangle {  //!!! TEMP - Notification area
      color: "darkslateblue";
      Layout.fillWidth: true;
      Layout.fillHeight: true;
    }
  }
}
