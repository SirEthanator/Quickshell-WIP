pragma ComponentBehavior: Bound

import qs.singletons
import qs.animations as Anims;
import QtQuick;

Item {
  id: root;
  anchors.fill: parent;

  property color color: Colors.c.fg;
  required property real percentage;
  required property bool charging;

  Rectangle {
    id: batteryBorder;

    anchors {
      right: batteryKnob.left;
      rightMargin: 1;
      left: parent.left;
      verticalCenter: parent.verticalCenter;
    }

    height: parent.height * 0.55;
    color: "transparent";
    radius: height * 0.27;

    border {
      color: root.color;
      width: root.height * 0.06;
    }

    Item {
      id: batteryFillWrapper;
      anchors {
        fill: parent;
        margins: parent.border.width + root.height * 0.04;
      }

      Rectangle {
        id: batteryFill;
        anchors {
          left: parent.left;
          top: parent.top;
          bottom: parent.bottom
        }

        color: root.color;
        radius: batteryBorder.radius - batteryFillWrapper.anchors.margins;

        readonly property real widthValue: parent.width * root.percentage;
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
      running: root.charging && root.percentage !== 1.0;
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

    height: batteryBorder.height / 2;
    width: root.width * 0.09;
    anchors.right: parent.right;
    anchors.verticalCenter: parent.verticalCenter;

    color: root.color;
    radius: width / 2;
  }
}
