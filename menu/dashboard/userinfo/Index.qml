import "root:/";
import "root:/utils" as Utils;
import "..";
import QtQuick.Layouts;

DashItem {
  id: root;

  fullContentWidth: true;
  hoverEnabled: true;

  Stack {
    id: stack;
    vertical: true;
    implicitHeight: info.height;
    Layout.fillWidth: true;

    Info {
      id: info
      onClicked: { stack.currentIndex = 1 }
    }

    Power {
      id: power;
      onGoBack: { stack.currentIndex = 0 }
      onLaunchConfirmation: {
        stack.currentIndex = 2;
        confirmation.startTimer()
      }
    }

    Confirmation {
      id: confirmation;
      action: power.selectedAction[0];
      actionFuture: power.selectedAction[1];
      command: power.selectedAction[3];
      onGoBack: { stack.currentIndex = 1 }
    }
  }
}

