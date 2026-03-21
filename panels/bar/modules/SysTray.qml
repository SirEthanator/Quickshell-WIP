pragma ComponentBehavior: Bound

import qs.singletons
import qs.panels.bar
import qs.components
import Quickshell.Services.SystemTray;
import QtQuick;
import QtQuick.Layouts;

BarModule {
  id: root;

  hoverEnabled: true;
  background: mouseArea.containsPress ? Colors.c.accent : mouseArea.containsMouse ? Colors.c.bgHover : Colors.c.bgLight;

  Icon {
    icon: "expand-symbolic";
    color: root.mouseArea.containsPress ? Colors.c.bgLight : Colors.c.fg;
    rotation: root.menuIsActive ? 180 : 0;
  }

  visible: SystemTray.items.values.length > 0;

  tooltip: Tooltip {
    Text {
      text: "Show system tray";
      color: Colors.c.fg;
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
