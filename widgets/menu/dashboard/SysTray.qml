import qs.singletons
import qs.panels.sidebar as Sidebar;
import qs.components
import Quickshell.Services.SystemTray;
import QtQuick;
import QtQuick.Layouts;

DashItem {
  id: root;

  visible: SystemTray.items.values.length > 0;

  GridLayout {
    id: trayButtons;
    rowSpacing: Consts.paddingMedium;
    columnSpacing: Consts.paddingMedium;

    TrayItems {
      onActivated: Sidebar.Controller.deactivate("menu");
    }
  }
}

