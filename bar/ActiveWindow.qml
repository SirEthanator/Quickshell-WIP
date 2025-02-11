import "root:/";
import "root:/utils" as Utils;
import "root:/animations" as Anims;
import QtQuick;

BarModule {
  icon: "display-symbolic";
  iconbgColour: Globals.colours.activeWindow;
  id: root;

  readonly property string title: Utils.HyprlandIPC.windowTitle;
  visible: title.length > 0;

  Text {
    color: Globals.colours.fg;
    font: Globals.vars.mainFont

    text: {
      const truncate = root.title.length > Globals.bar.truncationLength;
      const result = truncate ? `${root.title.substring(0, Globals.bar.truncationLength)}...` : root.title;
      return result;
    }

    Anims.OutIn on text {originalValue: 1}
  }
}

