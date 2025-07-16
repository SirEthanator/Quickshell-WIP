import qs
import QtQuick;
import QtQuick.Layouts;

Item {
  id: root;
  required property string action;
  required property string actionFuture;
  required property string command;

  signal goBack;

  anchors.left: parent.left;
  anchors.right: parent.right;

  property int countdown;

  function startTimer() {
    countdown = 5;
    countdownTimer.start();
  }

  Timer {
    id: countdownTimer;
    repeat: true;
    interval: 1000;
    onTriggered: {
      root.countdown --;
      if (root.countdown === 0) {
        confirmButton.runCmd();
      }
    }
  }

  ColumnLayout {
    id: content;
    spacing: Globals.vars.marginCardSmall;
    anchors.fill: parent;

    Text {
      Layout.alignment: Qt.AlignHCenter;
      text: `${root.action}?`;
      color: Globals.colours.fg;
      font {
        family: Globals.vars.fontFamily;
        pixelSize: Globals.vars.smallHeadingFontSize;
      }
    }

    Text {
      Layout.alignment: Qt.AlignHCenter;
      text: `${root.actionFuture} in ${root.countdown} seconds...`;
      color: Globals.colours.fg;
      font {
        family: Globals.vars.fontFamily;
        pixelSize: Globals.vars.mainFontSize;
      }
    }

    RowLayout {
      id: actions;
      Layout.fillWidth: true;

      uniformCellSizes: true;
      spacing: Globals.vars.spacingButtonGroup;

      ConfirmationButton {
        id: confirmButton;
        index: 0;
        label: `${root.action} now`;
        command: root.command;
      }

      ConfirmationButton {
        index: 1;
        label: "Cancel";
        onSelected: {
          countdownTimer.stop();
          root.goBack();
        }
      }
    }

  }
}

