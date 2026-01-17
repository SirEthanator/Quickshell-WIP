import qs.singletons
import qs.widgets.sidebar as Sidebar;
import qs.components
import QtQuick;

BarModule {
  id: root;
  hoverEnabled: true;
  background: root.mouseArea.containsMouse ? Globals.colours.accentLight : Globals.colours.accent;
  outline: false;
  onClicked: Sidebar.Controller.toggle("menu");
  padding: Consts.paddingModule*2;

  Icon {
    icon: "archlinux-logo";
    color: Globals.colours.bg;
  }
}

