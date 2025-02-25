pragma ComponentBehavior: Bound

import "root:/";
import "root:/dialog" as Dialog;
import "root:/dialog/createDialog.js" as CreateDialog;
import "root:/animations" as Anims;
import Quickshell.Io;
import QtQuick;
import QtQuick.Layouts;

GridLayout {
  id: power;
  required property var shellroot;
  required property var screen;
  Layout.fillWidth: true;
  columns: 3;
  rows: 3;
  columnSpacing: Globals.vars.spacingButtonGroup;
  rowSpacing: Globals.vars.spacingButtonGroup;

  Repeater {
    model: [
      ['Shut Down', 'Shutting Down', 'system-shutdown-symbolic', 'systemctl poweroff'],
      ['Reboot', 'Rebooting', 'system-reboot-symbolic', 'systemctl reboot'],
      ['Log Out', 'Logging Out', 'logout-symbolic', 'hyprctl dispatch exit'],
      ['Suspend', 'Suspending', 'system-hibernate-symbolic', 'gtklock & sleep 1; systemctl suspend'],
      ['Hibernate', 'Hibernating', 'system-suspend-hibernate-symbolic', 'systemctl hibernate'],
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
      topLeftRadius: index === 0 ? Globals.vars.br : 0;
      topRightRadius: index === 2 ? Globals.vars.br : 0;
      bottomLeftRadius: index === 3 ? Globals.vars.br : 0;
      bottomRightRadius: index === 5 ? Globals.vars.br : 0;

      Anims.ColourTransition on color {}

      Process { id: powercmd }

      MouseArea {
        id: powerButtonMouse;
        anchors.fill: parent;

        hoverEnabled: true;
        onClicked: {
          //powercmd.command = ['sh', '-c', `${powerButton.modelData[1]}`];
          //powercmd.running = true;
          Globals.states.menuOpen = false;
          CreateDialog.createDialog(power.shellroot,
          powerButton.modelData[0],
          `${powerButton.modelData[1]} in 5 seconds.`, [
            { name: `${powerButton.modelData[0]} now`, action: () => console.log("test"), fadeOut: true },
            { name: 'Cancel', close: true }
          ],
          power.screen);
        }

        Icon {
          id: powerIcon;
          anchors.centerIn: parent;
          icon: powerButton.modelData[2];
          color: powerButtonMouse.containsPress ? Globals.colours.bgLight : Globals.colours.fg;
          size: parent.height - Globals.vars.paddingButton*2;
          Anims.ColourTransition on color {}
        }
      }
    }
  }
}

