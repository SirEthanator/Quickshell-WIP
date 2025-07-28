import qs
import Quickshell.Services.UPower;
import QtQuick;

BarModule {
  id: root;

  readonly property var battery: UPower.displayDevice;
  readonly property int percentage: Math.round(battery.percentage*100)
  readonly property bool charging: battery.timeToEmpty === 0;

  show: battery.isLaptopBattery;

  icon: {
    const nearestTwenty = Math.round(percentage / 20) * 20;
    const number = nearestTwenty.toString().padStart(3, "0");
    const charging = root.charging ? "-charging" : "";
    return `battery-${number}${charging}`
  }

  forceIconbgColour: true;
  iconbgColour: {
    if (root.charging) {
      return Globals.colours.batteryCharging
    } else if (root.percentage <= 15) {
      return Globals.colours.batteryLow
    } else if (root.percentage <= 50) {
      return Globals.colours.batteryMed
    } else {
      return Globals.colours.battery
    }
  }

  Text {
    text: `${root.percentage}%`;
    color: Globals.colours.fg;
    font {
      family: Globals.vars.fontFamily;
      pixelSize: Globals.vars.mainFontSize;
    }
  }
}

