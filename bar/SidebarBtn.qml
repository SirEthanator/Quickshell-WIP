import "root:/";
import QtQuick;

BarModule {
  id: root;
  hoverEnabled: true;
  background: root.mouseArea.containsMouse ? Opts.colours.accentLight : Opts.colours.accent;
  onClicked: Opts.states.sidebarOpen = !Opts.states.sidebarOpen;

  Text {
    text: "";
    font: Opts.vars.nerdFont;
    color: Opts.colours.bg;
  }
}

