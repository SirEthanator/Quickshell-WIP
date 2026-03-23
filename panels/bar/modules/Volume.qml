import qs.singletons
import qs.panels.bar
import qs.widgets.volumemixer as VolumeMixer
import QtQuick;
import Quickshell.Services.Pipewire;

BarModule {
  id: root;
  readonly property PwNode node: SysInfo.audioNode;

  readonly property string volume: `${SysInfo.volume}%`;

  icon: SysInfo.volumeIcon;
  iconbgColor: Colors.c.volume;

  Text {
    color: Colors.c.fg;
    font {
      family: Consts.fontFamMain;
      pixelSize: Consts.fontSizeMain;
    }
    text: root.volume;
  }

  tooltip: Tooltip {
    Text {
      text: `Volume - ${root.volume}`;
      color: Colors.c.fg;
      font {
        family: Consts.fontFamMain;
        pixelSize: Consts.fontSizeMain;
      }
    }
  }

  menu: Tooltip {
    VolumeMixer.Index {}
  }
}
