pragma ComponentBehavior: Bound

import qs.singletons
import qs.components
import qs.widgets.bar
import qs.utils as Utils;
import Quickshell.Services.UPower;
import QtQuick;
import QtQuick.Layouts;

BarModule {
  id: root;

  readonly property var battery: UPower.displayDevice;
  readonly property real percentage: Math.round(battery.percentage*100) / 100;
  readonly property bool charging: battery.timeToEmpty === 0;

  show: battery.ready && battery.isLaptopBattery;

  customIcon: BatteryIcon {
    percentage: root.percentage;
    charging: root.charging;
    color: root.iconColor;
  }

  forceIconbgColor: true;
  iconbgColor: {
    if (root.charging) {
      return Colors.c.batteryCharging
    } else if (root.percentage <= .15) {
      return Colors.c.batteryLow
    } else if (root.percentage <= .50) {
      return Colors.c.batteryMed
    } else {
      return Colors.c.battery
    }
  }

  Text {
    text: `${root.percentage * 100}%`;
    color: Colors.c.fg;
    font {
      family: Consts.fontFamily;
      pixelSize: Consts.mainFontSize;
    }
  }

  tooltip: Tooltip {
    Text {
      text: `Battery - ${root.percentage * 100}%`;
      color: Colors.c.fg;
      font {
        family: Consts.fontFamily;
        pixelSize: Consts.mainFontSize;
      }
    }
  }

  menu: Tooltip {
    ColumnLayout {
      spacing: Consts.paddingModule;

      RowLayout {
        spacing: Consts.paddingModule;

        Item {
          Layout.fillHeight: true;
          implicitWidth: height;

          BatteryIcon {
            percentage: root.percentage;
            color: Colors.c.fg;
            charging: root.charging;
          }
        }

        Text {
          text: `${root.percentage * 100}%`;
          color: Colors.c.fg;
          font {
            family: Consts.fontFamily;
            pixelSize: Consts.smallHeadingFontSize;
          }
          Layout.alignment: Qt.AlignVCenter;
        }

        Text {
          readonly property string timeString: Utils.TimeString.letters(
            root.charging ? root.battery.timeToFull : root.battery.timeToEmpty,
            true
          );

          text: root.charging
            ? root.percentage === 1 ? "Fully Charged" : `Charging - ${timeString} until full`
            : `Discharging - ${timeString} remaining`;
          color: Colors.c.grey;
          font {
            family: Consts.fontFamily;
            pixelSize: Consts.mainFontSize;
          }
        }
      }

      Text {
        text: `Remaining capacity: ${Math.round(root.battery.energy)}Wh/${Math.round(root.battery.energyCapacity)}Wh`;
        color: Colors.c.fg;
        font {
          family: Consts.fontFamily;
          pixelSize: Consts.mainFontSize;
        }
      }

      Text {
        readonly property real changeRate: root.battery.changeRate;
        text: `${root.charging ? "Charge rate" : "Discharge rate"}: ${Math.round(changeRate)}W`;
        color: Colors.c.fg;

        visible: Math.abs(changeRate) > 0;

        font {
          family: Consts.fontFamily;
          pixelSize: Consts.mainFontSize;
        }
      }

      Text {
        text: `Battery health: ${root.battery.healthPercentage * 100}%`;
        color: Colors.c.fg;
        visible: root.battery.healthSupported && root.battery.healthPercentage > 0;
        font {
          family: Consts.fontFamily;
          pixelSize: Consts.mainFontSize;
        }
      }
    }
  }
}
