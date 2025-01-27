import "root:/";
import Quickshell;
import QtQuick;

BarModule {
  id: root;
  hoverEnabled: true;
  background: root.mouseArea.containsMouse ? Opts.colours.accentLight : Opts.colours.accent;

  Text {
    text: "";
    font: Opts.vars.nerdFont;
    color: Opts.colours.bg;
  }
}

