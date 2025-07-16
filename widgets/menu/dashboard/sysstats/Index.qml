import qs
import qs.utils
import qs.components
import "..";
import QtQuick;
import QtQuick.Layouts;

DashItem {
  id: root;
  fullContentWidth: true;

  ColumnLayout {
    id: column;

    spacing: Globals.vars.paddingCard;

    SysStatMonitor {
      percentage: SysInfo.cpuUsage;
      title: "CPU";
      extraInfo: `Temperature: ${SysInfo.cpuTemp}°C`;
    }

    SysStatMonitor {
      readonly property real usedMemory: (SysInfo.totalMemory - SysInfo.freeMemory).toFixed(2);
      percentage: usedMemory / SysInfo.totalMemory * 100;
      title: "Memory";
      extraInfo: `${usedMemory}GiB/${SysInfo.totalMemory}GiB Used`;
    }
  }
}

