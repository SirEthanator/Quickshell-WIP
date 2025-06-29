import "root:/";
import "root:/utils" as Utils;
import Quickshell;
import QtQuick;
import QtQuick.Layouts;
import Quickshell.Services.Pipewire;

BarModule {
  id: root;
  readonly property PwNode node: Utils.SysInfo.audioNode;

  readonly property int volume: Utils.SysInfo.volume;

  icon: Utils.SysInfo.volumeIcon;
  iconbgColour: Globals.colours.volume;

  Text {
    color: Globals.colours.fg;
    font {
      family: Globals.vars.fontFamily;
      pixelSize: Globals.vars.mainFontSize;
    }
    text: `${root.volume}%`;
  }
}

