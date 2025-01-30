import "root:/";
import "../utils" as Utils;
import Quickshell;
import Quickshell.Io
import QtQuick;

BarModule {
  icon: "display-symbolic";
  iconbgColour: Globals.colours.activeWindow;
  id: root;

  readonly property string title: `${Utils.HyprlandIPC.windowTitle}`;
  visible: (title.length > 0) ? true : false;

  Text {
    color: Globals.colours.fg;
    font: Globals.vars.mainFont

    text: {
      const tmp = root.title.length > Globals.bar.truncationLength;
      const result = tmp ? `${root.title.substring(0, Globals.bar.truncationLength)}...` : root.title;
      return result;
    }

    FadeAnimation on text {originalValue: 1}
  }
}

