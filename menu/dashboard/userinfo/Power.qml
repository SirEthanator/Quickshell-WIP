pragma ComponentBehavior: Bound

import "root:/";
import "root:/animations" as Anims;
import Quickshell.Io;
import QtQuick;
import QtQuick.Layouts;

GridLayout {
  id: power;
  anchors.left: parent.left;
  anchors.right: parent.right;
  columns: 3;
  rows: 3;
  columnSpacing: Globals.vars.spacingButtonGroup;
  rowSpacing: Globals.vars.spacingButtonGroup;
  uniformCellWidths: true;
  uniformCellHeights: true;

  signal goBack;
  signal launchConfirmation;

  property list<string> selectedAction;

  Repeater {
    model: [
      ['', '', 'back-symbolic', () => power.goBack()],
      ['Shut Down', 'Shutting Down', 'system-shutdown-symbolic', 'systemctl poweroff'],
      ['Reboot', 'Rebooting', 'system-reboot-symbolic', 'systemctl reboot'],
      ['Log Out', 'Logging Out', 'logout-symbolic', 'hyprctl dispatch exit'],
      ['Suspend', 'Suspending', 'system-hibernate-symbolic', 'gtklock & sleep 1; systemctl suspend'],
      ['Reboot to FW Settings', 'Rebooting to FW Settings', 'preferences-advanced-symbolic', 'systemctl reboot --firmware-setup']
    ]

    Rectangle {
      id: powerButton;
      required property var modelData;
      required property int index;
      Layout.fillWidth: true;
      Layout.fillHeight: true;

      color: powerButtonMouse.containsPress
        ? Globals.colours.accent
        : powerButtonMouse.containsMouse
          ? Globals.colours.bgHover
          : Globals.colours.bg;
      topLeftRadius: index === 0 || powerButtonMouse.containsMouse ? Globals.vars.br : 0;
      topRightRadius: index === 2 || powerButtonMouse.containsMouse ? Globals.vars.br : 0;
      bottomLeftRadius: index === 3 || powerButtonMouse.containsMouse ? Globals.vars.br : 0;
      bottomRightRadius: index === 5 || powerButtonMouse.containsMouse ? Globals.vars.br : 0;

      Anims.NumberTransition on topLeftRadius {}
      Anims.NumberTransition on topRightRadius {}
      Anims.NumberTransition on bottomLeftRadius {}
      Anims.NumberTransition on bottomRightRadius {}

      Anims.ColourTransition on color {}

      Process { id: powercmd }

      MouseArea {
        id: powerButtonMouse;
        anchors.fill: parent;

        hoverEnabled: true;
        onClicked: {
          const action = powerButton.modelData[3];
          if (typeof action === "function") {
            action()
          } else {
            //powercmd.command = ['sh', '-c', action];
            //powercmd.running = true;
            selectedAction = powerButton.modelData;
            launchConfirmation();
            // Globals.states.menuOpen = false;
          }
        }

        Icon {
          id: powerIcon;
          anchors.centerIn: powerButtonMouse;
          icon: powerButton.modelData[2];
          color: powerButtonMouse.containsPress ? Globals.colours.bgLight : Globals.colours.fg;
          size: parent.height - Globals.vars.paddingButton*2;
          Anims.ColourTransition on color {}
        }
      }
    }
  }
}

