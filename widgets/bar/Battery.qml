pragma ComponentBehavior: Bound

import qs
import qs.utils as Utils
import qs.animations as Anims
import Quickshell.Services.UPower;
import QtQuick;

BarModule {
  id: root;

  readonly property var battery: UPower.displayDevice;
  readonly property int percentage: Math.round(battery.percentage*100);
  readonly property bool charging: battery.timeToEmpty === 0;

  show: battery.isLaptopBattery;

  customIcon: Item {
    anchors.fill: parent;

    Rectangle {
      id: batteryBorder;

      anchors {
        right: batteryKnob.left;
        rightMargin: 1;
        left: parent.left;
        verticalCenter: parent.verticalCenter;
      }

      height: parent.height - 10;
      color: "transparent";
      radius: 3;

      border {
        color: root.iconColour;
        width: 1.5;
      }

      Item {
        id: batteryFillWrapper;
        anchors {
          fill: parent;
          margins: parent.border.width + 0.8;
        }

        Rectangle {
          id: batteryFill;
          anchors {
            left: parent.left;
            top: parent.top;
            bottom: parent.bottom
          }

          color: root.iconColour;
          radius: batteryBorder.radius - 0.8;

          readonly property real widthValue: parent.width * (root.percentage / 100);
          width: widthValue;

          // For charging animation
          readonly property int stepCount: 5;
          readonly property real targetWidth: parent.width;
          readonly property real stepSize: (targetWidth - widthValue) / stepCount;
          readonly property int stepDuration: 300;

          Anims.NumberTransition on width {}
        }
      }

      SequentialAnimation {
        id: chargingAnim;
        running: root.charging && root.show && root.percentage !== 100;
        loops: Animation.Infinite;

        onRunningChanged: {
          if (!running) {
            batteryFill.width = Qt.binding(() => batteryFill.widthValue);
          }
        }

        ScriptAction {
          id: chargingAnimSteps;
          script: {
            for (let i=0; i < batteryFill.stepCount; i++) {
              Utils.Timeout.setTimeout(() => {
                if (chargingAnim.running) {
                  batteryFill.width = batteryFill.widthValue + batteryFill.stepSize * (i+1);
                }
              }, i * batteryFill.stepDuration)
            }
          }
        }

        // Hold at full
        PauseAnimation { duration: batteryFill.stepCount * batteryFill.stepDuration + 800 }

        // Reset to original percentage
        Anims.NumberAnim {
          target: batteryFill;
          property: "width";
          to: batteryFill.widthValue;
        }

        // Pause before repeating
        PauseAnimation { duration: 1000 }
      }
    }

    Rectangle {
      id: batteryKnob;

      height: 5;
      width: 2;
      anchors.right: parent.right;
      anchors.verticalCenter: parent.verticalCenter;

      color: root.iconColour;
      radius: width / 2;
    }
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

