pragma ComponentBehavior: Bound

import qs.singletons
import qs.widgets.bar
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
        color: root.iconColor;
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

          color: root.iconColor;
          radius: batteryBorder.radius - 0.8;

          readonly property real widthValue: parent.width * (root.percentage / 100);
          width: widthValue;

          // For charging animation
          readonly property int stepCount: 5;
          readonly property real targetWidth: parent.width;
          readonly property real stepSize: (targetWidth - widthValue) / stepCount;
          readonly property int stepDuration: 350;

          Anims.NumberTransition on width {}
        }
      }

      Instantiator {
        id: chargingAnimStepTimers;
        model: batteryFill.stepCount;

        function restart() {
          for (let i=0; i < count; i++) {
            (objectAt(i) as Timer).restart();
          }
        }

        function stop() {
          for (let i=0; i < count; i++) {
            (objectAt(i) as Timer).stop();
          }
        }

        delegate: Timer {
          required property int modelData;
          interval: batteryFill.stepDuration * modelData;
          repeat: false;

          onTriggered: {
            if (chargingAnim.running) {
              batteryFill.width = batteryFill.widthValue + batteryFill.stepSize * (modelData+1);
            }
          }
        }
      }

      SequentialAnimation {
        id: chargingAnim;
        running: root.charging && root.show && root.percentage !== 100;
        loops: Animation.Infinite;

        onRunningChanged: {
          if (!running) {
            batteryFill.width = Qt.binding(() => batteryFill.widthValue);
            chargingAnimStepTimers.stop();
          }
        }

        ScriptAction {
          script: { chargingAnimStepTimers.restart() }
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

      color: root.iconColor;
      radius: width / 2;
    }
  }


  forceIconbgColor: true;
  iconbgColor: {
    if (root.charging) {
      return Globals.colors.batteryCharging
    } else if (root.percentage <= 15) {
      return Globals.colors.batteryLow
    } else if (root.percentage <= 50) {
      return Globals.colors.batteryMed
    } else {
      return Globals.colors.battery
    }
  }

  Text {
    text: `${root.percentage}%`;
    color: Globals.colors.fg;
    font {
      family: Consts.fontFamily;
      pixelSize: Consts.mainFontSize;
    }
  }

  tooltip: Tooltip {
    Text {
      text: `Battery - ${root.percentage}%`;
      color: Globals.colors.fg;
      font {
        family: Consts.fontFamily;
        pixelSize: Consts.mainFontSize;
      }
    }
  }
}
