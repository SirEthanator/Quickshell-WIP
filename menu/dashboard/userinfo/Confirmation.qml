import "root:/";
import Quickshell.Io;
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

  Process { id: cmd }

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
        cmd.command = ["sh", "-c", root.command];
        cmd.running = true;
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
        index: 0;
        text: `${root.action} now`;
        command: root.command;
        closeMenu: true;
      }

      ConfirmationButton {
        index: 1;
        text: "Cancel";
        onSelected: {
          countdownTimer.stop();
          root.goBack();
        }
      }
    }

  }
}

