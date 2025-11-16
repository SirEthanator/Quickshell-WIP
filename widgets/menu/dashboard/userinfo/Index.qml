import qs.components
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
      title: power.selectedAction.title;
      titleFuture: power.selectedAction.titleFuture;
      action: power.selectedAction.action;
      command: power.selectedAction.command;
      onGoBack: { stack.currentIndex = 1 }
    }
  }
}

