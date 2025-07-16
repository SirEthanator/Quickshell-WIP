import qs
import qs.utils as Utils;
import QtQuick;
import Quickshell.Services.Pipewire;

BarModule {
  id: root;
  readonly property PwNode node: Utils.SysInfo.audioNode;

  readonly property string volume: `${Utils.SysInfo.volume}%`;

  icon: Utils.SysInfo.volumeIcon;
  iconbgColour: Globals.colours.volume;

  Text {
    color: Globals.colours.fg;
    font {
      family: Globals.vars.fontFamily;
      pixelSize: Globals.vars.mainFontSize;
    }
    text: root.volume;
  }
}

