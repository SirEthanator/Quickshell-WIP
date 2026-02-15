import qs.singletons
import qs.widgets.bar
import QtQuick;

BarModule {
  id: root;

  icon: {
    const strength = SysInfo.networkStrength;
    if (strength > 75) { return "nm-signal-100" } else
    if (strength > 50) { return "nm-signal-75"  } else
    if (strength > 25) { return "nm-signal-50"  }
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

  tooltip: Tooltip {
    Text {
      text: `Connected to "${SysInfo.network}" with strength ${SysInfo.networkStrength}`;
      color: Globals.colours.fg;
      font {
        family: Consts.fontFamily;
        pixelSize: Consts.mainFontSize;
      }
    }
  }
}
