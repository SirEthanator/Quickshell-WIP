import "root:/";
import QtQuick;

BarModule {
  id: root;
  hoverEnabled: true;
  background: root.mouseArea.containsMouse ? Globals.colours.accentLight : Globals.colours.accent;
  onClicked: Globals.states.sidebarOpen = !Globals.states.sidebarOpen;
  padding: Globals.vars.paddingModule*2;

  Text {
    text: "";
    font: Globals.vars.nerdFont;
    color: Globals.colours.bg;
  }
}

