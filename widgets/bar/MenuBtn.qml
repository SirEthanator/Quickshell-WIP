import "root:/";
import QtQuick;

BarModule {
  id: root;
  hoverEnabled: true;
  background: root.mouseArea.containsMouse ? Globals.colours.accentLight : Globals.colours.accent;
  outline: false;
  onClicked: Globals.states.menuOpen = !Globals.states.menuOpen;
  padding: Globals.vars.paddingModule*2;

  Text {
    text: "";
    font: Globals.vars.nerdFont;
    color: Globals.colours.bg;
  }
}

