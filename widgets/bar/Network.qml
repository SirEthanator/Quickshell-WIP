import qs.singletons
import QtQuick;

BarModule {
  id: root;

  icon: {
    if (SysInfo.networkStrength > 75) { return "nm-signal-100" } else
    if (SysInfo.networkStrength > 50) { return "nm-signal-75"  } else
    if (SysInfo.networkStrength > 25) { return "nm-signal-50"  }
    else { return "nm-signal-25" }
  }
  iconbgColour: Globals.colours.network;

  show: SysInfo.networkStrength > 0;

  Text {
    text: SysInfo.network;
    color: Globals.colours.fg;
    font {
      family: Consts.fontFamily;
      pixelSize: Consts.mainFontSize;
    }
  }
}

