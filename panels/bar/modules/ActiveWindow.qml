import qs.singletons
import qs.panels.bar
import qs.animations as Anims;
import Quickshell.Wayland;
import QtQuick;

BarModule {
  icon: "display-symbolic";
  iconbgColor: Colors.c.activeWindow;
  id: root;

  readonly property string title: (!!ToplevelManager.activeToplevel && !!ToplevelManager.activeToplevel.title) ? ToplevelManager.activeToplevel.title : "";
  visible: title.length > 0;

  Text {
    color: Colors.c.fg;
    font {
      family: Consts.fontFamily;
      pixelSize: Consts.mainFontSize;
    }

    text: {
      const truncate = root.title.length > Conf.bar.truncationLength;
      const result = truncate ? `${root.title.substring(0, Conf.bar.truncationLength)}...` : root.title;
      return result;
    }

    Anims.OutIn on text { originalValue: 1; fadeDuration: 100 }
  }

  tooltip: Tooltip {
    Text {
      text: `Active window - ${root.title}`;
      color: Colors.c.fg;
      font {
        family: Consts.fontFamily;
        pixelSize: Consts.mainFontSize;
      }
    }
  }
}
