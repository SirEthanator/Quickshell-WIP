import "root:/";
import Quickshell;
import QtQuick;
import QtQuick.Layouts;
import "userinfo" as UserInfo;
import "sysstats" as SysStats;

Item {
  id: dashboard;

  ColumnLayout {
    anchors.fill: parent;
    spacing: Globals.vars.paddingWindow;

    UserInfo.Index {}

    SysStats.CPU {}
    SysStats.Memory {}

    SysTray {}

    Item { Layout.fillHeight: true; } // TEMP - Notification area
  }
}
