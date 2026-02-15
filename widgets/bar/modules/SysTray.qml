pragma ComponentBehavior: Bound

import qs.singletons
import qs.widgets.bar
import qs.components
import Quickshell.Services.SystemTray;
import QtQuick;
import QtQuick.Layouts;

BarModule {
  id: root;
  required property var window;

  hoverEnabled: true;
  background: mouseArea.containsPress ? Globals.colours.accent : mouseArea.containsMouse ? Globals.colours.bgHover : Globals.colours.bgLight;

  Icon {
    icon: "expand-symbolic";
    color: root.mouseArea.containsPress ? Globals.colours.bgLight : Globals.colours.fg;
    rotation: root.menuIsActive ? 180 : 0;
  }

  visible: SystemTray.items.values.length > 0;

  tooltip: Tooltip {
    Text {
      text: "Show system tray";
      color: Globals.colours.fg;
      font {
        family: Consts.fontFamily;
        pixelSize: Consts.mainFontSize;
      }
    }
  }

  menu: Tooltip {
    GridLayout {
      id: trayButtons;
      columns: 5;
      rowSpacing: Consts.marginCard;
      columnSpacing: Consts.marginCard;

      TrayItems {
        onActivated: TooltipController.clearTooltip();
      }
    }
  }
}
