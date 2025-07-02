import "root:/";
import "root:/components";
import "root:/utils" as Utils;
import "root:/widgets/desktop" as Desktop;
import Quickshell.Wayland;
import QtQuick;
import QtQuick.Layouts;

WlSessionLockSurface {
  id: root;

  required property WlSessionLock lock;

  color: Globals.colours.bg;

  Pam {
    id: pam;
    lock: root.lock;
    onPasswordChanged: {
      if (password !== input.field.text) input.field.text = password;
    }
  }

  Desktop.Wallpaper {}

  Rectangle {
    id: contentBg;

    anchors {
      left: parent.left;
      top: parent.top;
      bottom: parent.bottom;
      margins: Globals.vars.gapLarge;
    }
    width: 600;

    color: Globals.colours.bg;
    radius: Globals.vars.br;

    ColumnLayout {
      anchors.fill: parent;
      anchors.margins: Globals.vars.paddingWindow;
      spacing: Globals.vars.paddingWindow * 4;

      Item { Layout.fillHeight: true }

      Clock {}

      PassInput { id: input; pam: pam }

      Item { Layout.fillHeight: true }

      Status { pam: pam }
    }
  }
}

