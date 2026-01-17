import qs.singletons
import qs.widgets.sidebar as Sidebar;
import qs.components
import Quickshell.Services.SystemTray;
import QtQuick;
import QtQuick.Layouts;

DashItem {
  id: root;

  visible: SystemTray.items.values.length > 0;

  GridLayout {
    id: trayButtons;
    rowSpacing: Consts.marginCard;
    columnSpacing: Consts.marginCard;

    TrayItems {
      onActivated: Sidebar.Controller.deactivate("menu");
    }
  }
}

