pragma ComponentBehavior: Bound

import qs
import qs.components
import qs.animations as Anims;
import Quickshell.Io;
import QtQuick;
import QtQuick.Layouts;

GridLayout {
  id: root;
  anchors.left: parent.left;
  anchors.right: parent.right;
  columns: 3;
  rows: 2;
  columnSpacing: Globals.vars.spacingButtonGroup;
  rowSpacing: Globals.vars.spacingButtonGroup;
  uniformCellWidths: true;
  uniformCellHeights: true;

  signal goBack;
  signal launchConfirmation;

  property list<string> selectedAction;

  Repeater {
    model: [
      ['', '', 'back-symbolic', () => root.goBack()],
      ['Shut Down', 'Shutting Down', 'system-shutdown-symbolic', 'systemctl poweroff'],
      ['Reboot', 'Rebooting', 'system-reboot-symbolic', 'systemctl reboot'],
      ['Log Out', 'Logging Out', 'logout-symbolic', 'hyprctl dispatch exit'],
      ['Suspend', 'Suspending', 'system-hibernate-symbolic', 'loginctl lock-session & sleep 1; systemctl suspend'],
      ['Reboot to FW Settings', 'Rebooting to FW Settings', 'preferences-advanced-symbolic', 'systemctl reboot --firmware-setup']
    ]

    Button {
      id: powerBtn;
      required property var modelData;
      required property int index;
      icon: modelData[2];
      Layout.fillWidth: true;
      Layout.fillHeight: true;

      tlRadius: index === 0;
      trRadius: index === 2;
      blRadius: index === 3;
      brRadius: index === 5;

      padding: Globals.vars.paddingButtonIcon;

      Process { id: powerCmd }
      onClicked: {
        const action = powerBtn.modelData[3];
        if (typeof action === "function") action()
        else {
          root.selectedAction = powerBtn.modelData;
          root.launchConfirmation();
        }
      }
    }
  }
}

