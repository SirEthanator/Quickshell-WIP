import qs.singletons
import qs.panels.bar
import QtQuick;

BarModule {
  id: root;

  icon: {
    const strength = NetworkInfo.connectedNetwork.signalStrength * 100;
    if (strength > 75) { return "nm-signal-100" } else
    if (strength > 50) { return "nm-signal-75"  } else
    if (strength > 25) { return "nm-signal-50"  }
    else { return "nm-signal-25" }
  }
  iconbgColor: Colors.c.network;

  show: NetworkInfo.connectedNetwork !== null;

  Text {
    text: NetworkInfo.connectedNetwork.name;
    color: Colors.c.fg;
    font {
      family: Consts.fontFamily;
      pixelSize: Consts.mainFontSize;
    }
  }

  tooltip: Tooltip {
    Text {
      text: `Connected to "${NetworkInfo.connectedNetwork.name}" with strength ${Math.round(NetworkInfo.connectedNetwork.signalStrength * 100)}%`;
      color: Colors.c.fg;
      font {
        family: Consts.fontFamily;
        pixelSize: Consts.mainFontSize;
      }
    }
  }
}
