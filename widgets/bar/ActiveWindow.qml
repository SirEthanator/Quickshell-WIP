import "root:/";
import "root:/utils" as Utils;
import "root:/animations" as Anims;
import Quickshell.Wayland;
import QtQuick;

BarModule {
  icon: "display-symbolic";
  iconbgColour: Globals.colours.activeWindow;
  id: root;

  readonly property string title: (!!ToplevelManager.activeToplevel && !!ToplevelManager.activeToplevel.title) ? ToplevelManager.activeToplevel.title : "";
  show: title.length > 0;

  Text {
    color: Globals.colours.fg;
    font {
      family: Globals.vars.fontFamily;
      pixelSize: Globals.vars.mainFontSize;
    }

    text: {
      const truncate = root.title.length > Globals.conf.bar.truncationLength;
      const result = truncate ? `${root.title.substring(0, Globals.conf.bar.truncationLength)}...` : root.title;
      return result;
    }

    Anims.OutIn on text { originalValue: 1; fadeDuration: 100 }
  }
}

