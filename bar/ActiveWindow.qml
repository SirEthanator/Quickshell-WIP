import "..";
import "../utils" as Utils;
import Quickshell;
import Quickshell.Io
import QtQuick;

BarModule {
  icon: "window-symbolic";
  id: root;

  readonly property string title: `${Utils.HyprlandIPC.windowTitle}`;
  visible: (title.length > 0) ? true : false;

  Text {
    color: Opts.colours.fg;
    font.pixelSize: Opts.vars.fontMain;

    text: {
      const tmp = root.title.length > Opts.bar.truncationLength;
      const result = tmp ? `${root.title.substring(0, Opts.bar.truncationLength)}...` : root.title;
      return result;
    }

    FadeAnimation on text {originalValue: 1}
  }
}

