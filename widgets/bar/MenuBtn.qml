import qs
import qs.components
import QtQuick;

BarModule {
  id: root;
  hoverEnabled: true;
  background: root.mouseArea.containsMouse ? Globals.colours.accentLight : Globals.colours.accent;
  outline: false;
  onClicked: Globals.states.menuOpen = !Globals.states.menuOpen;
  padding: Globals.vars.paddingModule*2;

  Icon {
    icon: "archlinux-logo";
    color: Globals.colours.bg;
  }
}

