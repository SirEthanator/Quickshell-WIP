import "root:/";
import "root:/components";
import QtQuick;
import QtQuick.Layouts;

DashItem {
  id: root;

  GridLayout {
    id: trayButtons;
    rowSpacing: Globals.vars.marginCard;
    columnSpacing: Globals.vars.marginCard;

    TrayItems {}
  }
}

