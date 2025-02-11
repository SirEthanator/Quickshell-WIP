import "root:/";
import "root:/utils" as Utils;
import QtQuick;

BarModule {
  id: root;

  icon: {
    if (Utils.SysInfo.networkStrength > 75) { return "nm-signal-100" } else
    if (Utils.SysInfo.networkStrength > 50) { return "nm-signal-75"  } else
    if (Utils.SysInfo.networkStrength > 25) { return "nm-signal-50"  }
    else { return "nm-signal-25" }
  }

  visible: Utils.SysInfo.networkStrength > 0;

  Text {
    text: Utils.SysInfo.network;
    color: Globals.colours.fg;
    font: Globals.vars.mainFont;
  }
}

