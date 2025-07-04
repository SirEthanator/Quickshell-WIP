import "root:/";
import "root:/utils" as Utils;
import QtQuick;
import Quickshell.Services.Pipewire;

BarModule {
  id: root;
  readonly property PwNode node: Utils.SysInfo.audioNode;

  readonly property string volume: `${Utils.SysInfo.volume}%`;

  icon: Utils.SysInfo.volumeIcon;
  iconbgColour: Globals.colours.volume;

  tooltip: TooltipItem {
    // Placeholder - Replace with list of audio devices with sliders
    Text {
      text: root.volume;
      color: Globals.colours.fg;
      font {
        family: Globals.vars.fontFamily;
        pixelSize: Globals.vars.mainFontSize;
      }
    }
  }

  Text {
    color: Globals.colours.fg;
    font {
      family: Globals.vars.fontFamily;
      pixelSize: Globals.vars.mainFontSize;
    }
    text: root.volume;
  }
}

