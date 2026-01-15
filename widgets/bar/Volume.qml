import qs.singletons
import QtQuick;
import Quickshell.Services.Pipewire;

BarModule {
  id: root;
  readonly property PwNode node: SysInfo.audioNode;

  readonly property string volume: `${SysInfo.volume}%`;

  icon: SysInfo.volumeIcon;
  iconbgColour: Globals.colours.volume;

  Text {
    color: Globals.colours.fg;
    font {
      family: Consts.fontFamily;
      pixelSize: Consts.mainFontSize;
    }
    text: root.volume;
  }
}

