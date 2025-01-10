import "..";
import "../utils" as Utils;
import Quickshell;
import Quickshell.Io
import QtQuick;

BarModule {
  id: root;
  implicitWidth: activeWindow.implicitWidth + Opts.vars.paddingModule;

  readonly property string title: `${Utils.HyprlandIPC.windowTitle}`;
  visible: (title.length > 0) ? true : false;

  Text {
    id: activeWindow;
    anchors.centerIn: parent;
    color: Opts.colours.fg;
    font.pixelSize: Opts.vars.fontMain;

    text: root.title;

    FadeAnimation on text {originalValue: 1}
  }
}

