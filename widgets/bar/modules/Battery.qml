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
      return Globals.colors.batteryCharging
    } else if (root.percentage <= .15) {
      return Globals.colors.batteryLow
    } else if (root.percentage <= .50) {
      return Globals.colors.batteryMed
    } else {
      return Globals.colors.battery
    }
  }

  Text {
    text: `${root.percentage * 100}%`;
    color: Globals.colors.fg;
    font {
      family: Consts.fontFamily;
      pixelSize: Consts.mainFontSize;
    }
  }

  tooltip: Tooltip {
    Text {
      text: `Battery - ${root.percentage * 100}%`;
      color: Globals.colors.fg;
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
            color: Globals.colors.fg;
            charging: root.charging;
          }
        }

        Text {
          text: `${root.percentage * 100}%`;
          color: Globals.colors.fg;
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

          text: root.percentage === 1
            ? "Fully Charged"
            : root.charging
              ? `Charging - ${timeString} until full`
              : `Discharging - ${timeString} remaining`;
          color: Globals.colors.grey;
          font {
            family: Consts.fontFamily;
            pixelSize: Consts.mainFontSize;
          }
        }
      }

      Text {
        text: `Remaining capacity: ${Math.round(root.battery.energy)}Wh/${Math.round(root.battery.energyCapacity)}Wh`;
        color: Globals.colors.fg;
        font {
          family: Consts.fontFamily;
          pixelSize: Consts.mainFontSize;
        }
      }

      Text {
        readonly property real changeRate: root.battery.changeRate;
        text: `${root.charging ? "Charge rate" : "Discharge rate"}: ${Math.round(changeRate)}W`;
        color: Globals.colors.fg;

        visible: Math.abs(changeRate) > 0;

        font {
          family: Consts.fontFamily;
          pixelSize: Consts.mainFontSize;
        }
      }

      Text {
        text: `Battery health: ${root.battery.healthPercentage * 100}%`;
        color: Globals.colors.fg;
        visible: root.battery.healthSupported && root.battery.healthPercentage > 0;
        font {
          family: Consts.fontFamily;
          pixelSize: Consts.mainFontSize;
        }
      }
    }
  }
}
