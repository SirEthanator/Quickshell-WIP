import qs.singletons
import QtQuick;
import QtQuick.Layouts;

Item {
  id: root;
  required property string title;
  required property string titleFuture;
  property string command;
  property var action;

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
      root.countdown--;
      if (root.countdown === 0) {
        confirmButton.runCmd();
      }
    }
  }

  ColumnLayout {
    id: content;
    spacing: Consts.marginCardSmall;
    anchors.fill: parent;

    Text {
      Layout.alignment: Qt.AlignHCenter;
      text: `${root.title}?`;
      color: Globals.colours.fg;
      font {
        family: Consts.fontFamily;
        pixelSize: Consts.smallHeadingFontSize;
      }
    }

    Text {
      Layout.alignment: Qt.AlignHCenter;
      text: `${root.titleFuture} in ${root.countdown} seconds...`;
      color: Globals.colours.fg;
      font {
        family: Consts.fontFamily;
        pixelSize: Consts.mainFontSize;
      }
    }

    RowLayout {
      id: actions;
      Layout.fillWidth: true;

      uniformCellSizes: true;
      spacing: Consts.spacingButtonGroup;

      ConfirmationButton {
        id: confirmButton;
        index: 0;
        label: `${root.title} now`;
        command: root.command;
        action: root.action;
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

