pragma ComponentBehavior: Bound

import qs.singletons
import qs.components
import qs.panels.bar
import qs.utils as Utils;
import Quickshell.Services.UPower;
import QtQuick;
import QtQuick.Layouts;

BarModule {
  id: root;

  readonly property var battery: UPower.displayDevice;
  readonly property real percentage: Math.round(battery.percentage*100) / 100;
  readonly property int percentageInt: Math.round(percentage * 100);
  readonly property bool charging: battery.timeToEmpty === 0;

  visible: battery.ready && battery.isLaptopBattery;

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
    text: `${root.percentageInt}%`;
    color: Colors.c.fg;
    font {
      family: Consts.fontFamMain;
      pixelSize: Consts.fontSizeMain;
    }
  }

  tooltip: Tooltip {
    Text {
      text: `Battery - ${root.percentageInt}%`;
      color: Colors.c.fg;
      font {
        family: Consts.fontFamMain;
        pixelSize: Consts.fontSizeMain;
      }
    }
  }

  menu: Tooltip {
    ColumnLayout {
      spacing: Consts.paddingSmall;

      RowLayout {
        spacing: Consts.paddingSmall;

        Item {
          Layout.fillHeight: true;
          implicitWidth: height;

          Layout.minimumWidth: 40;
          Layout.minimumHeight: Layout.minimumWidth;

          BatteryIcon {
            percentage: root.percentage;
            color: Colors.c.fg;
            charging: root.charging;

            anchors.margins: 8;
          }

          CircularProgress {
            anchors.fill: parent;
            value: root.percentage;
            bg: Colors.c.bgAccent;
            showText: false;
            thickness: 3;
          }
        }

        Text {
          text: `${root.percentageInt}%`;
          color: Colors.c.fg;
          font {
            family: Consts.fontFamMain;
            pixelSize: Consts.fontSizeSmallLarge;
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
            family: Consts.fontFamMain;
            pixelSize: Consts.fontSizeMain;
          }
        }
      }

      Text {
        text: `Remaining capacity: ${Math.round(root.battery.energy)}Wh/${Math.round(root.battery.energyCapacity)}Wh`;
        color: Colors.c.fg;
        font {
          family: Consts.fontFamMain;
          pixelSize: Consts.fontSizeMain;
        }
      }

      Text {
        readonly property real changeRate: root.battery.changeRate;
        text: `${root.charging ? "Charge rate" : "Discharge rate"}: ${Math.round(changeRate)}W`;
        color: Colors.c.fg;

        visible: Math.abs(changeRate) > 0;

        font {
          family: Consts.fontFamMain;
          pixelSize: Consts.fontSizeMain;
        }
      }

      Text {
        text: `Battery health: ${root.battery.healthPercentage * 100}%`;
        color: Colors.c.fg;
        visible: root.battery.healthSupported && root.battery.healthPercentage > 0;
        font {
          family: Consts.fontFamMain;
          pixelSize: Consts.fontSizeMain;
        }
      }
    }
  }
}
