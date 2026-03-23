import qs.singletons
import qs.panels.bar
import qs.panels.sidebar as Sidebar;
import qs.components
import QtQuick;

BarModule {
  id: root;
  hoverEnabled: true;
  background: root.mouseArea.containsMouse ? Colors.c.accentLight : Colors.c.accent;
  outline: false;
  onClicked: Sidebar.Controller.toggle("menu");
  padding: Consts.paddingSmall*2;

  Icon {
    icon: "archlinux-logo";
    color: Colors.c.bg;
  }

  tooltip: Tooltip {
    Text {
      text: "Toggle menu";
      color: Colors.c.fg;
      font {
        family: Consts.fontFamMain;
        pixelSize: Consts.fontSizeMain;
      }
    }
  }
}
