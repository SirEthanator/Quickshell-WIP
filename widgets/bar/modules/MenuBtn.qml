import qs.singletons
import qs.widgets.bar
import qs.widgets.sidebar as Sidebar;
import qs.components
import QtQuick;

BarModule {
  id: root;
  hoverEnabled: true;
  background: root.mouseArea.containsMouse ? Globals.colors.accentLight : Globals.colors.accent;
  outline: false;
  onClicked: Sidebar.Controller.toggle("menu");
  padding: Consts.paddingModule*2;

  Icon {
    icon: "archlinux-logo";
    color: Globals.colors.bg;
  }

  tooltip: Tooltip {
    Text {
      text: "Toggle menu";
      color: Globals.colors.fg;
      font {
        family: Consts.fontFamily;
        pixelSize: Consts.mainFontSize;
      }
    }
  }
}
