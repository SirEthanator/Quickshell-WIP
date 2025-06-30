import "root:/";
import QtQuick;
import QtQuick.Layouts;
import "userinfo" as UserInfo;
import "sysstats" as SysStats;

ColumnLayout {
  spacing: Globals.vars.paddingWindow;

  UserInfo.Index {}

  SysStats.Index {}

  SysTray {}

  NotifCentre {}
}

