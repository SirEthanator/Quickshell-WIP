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

    SysStats.CPU {}
    SysStats.Memory {}

    Rectangle {  //!!! TEMP - Notification area
      color: "darkslateblue";
      Layout.fillWidth: true;
      Layout.fillHeight: true;
    }
  }
}
