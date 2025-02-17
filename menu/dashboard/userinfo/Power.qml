import "root:/";
import "root:/animations" as Anims;
import Quickshell.Io;
import QtQuick;
import QtQuick.Layouts;

GridLayout {
  id: power;
  Layout.fillWidth: true;
  columns: 3;
  rows: 3;
  columnSpacing: 3;
  rowSpacing: 3;

  Repeater {
    model: [
      ['system-shutdown-symbolic', 'systemctl poweroff'],
      ['system-reboot-symbolic', 'systemctl reboot'],
      ['logout-symbolic', 'hyprctl dispatch exit'],
      ['system-hibernate-symbolic', 'gtklock & sleep 1; systemctl suspend'],
      ['system-suspend-hibernate-symbolic', 'systemctl hibernate'],
      ['preferences-advanced-symbolic', 'systemctl reboot --firmware-setup']
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
          powercmd.command = ['sh', '-c', `${powerButton.modelData[1]}`];
          powercmd.running = true;
        }

        Icon {
          id: powerIcon;
          anchors.centerIn: parent;
          icon: powerButton.modelData[0];
          color: powerButtonMouse.containsPress ? Globals.colours.bgLight : Globals.colours.fg;
          size: parent.height - Globals.vars.paddingButton*2;
          Anims.ColourTransition on color {}
        }
      }
    }
  }
}

