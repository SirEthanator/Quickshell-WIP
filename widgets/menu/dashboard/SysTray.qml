import qs
import qs.components
import Quickshell.Services.SystemTray;
import QtQuick;
import QtQuick.Layouts;

DashItem {
  id: root;

  visible: SystemTray.items.values.length > 0;

  GridLayout {
    id: trayButtons;
    rowSpacing: Globals.vars.marginCard;
    columnSpacing: Globals.vars.marginCard;

    TrayItems {
      onActivated: Globals.states.menuOpen = false;
    }
  }
}

