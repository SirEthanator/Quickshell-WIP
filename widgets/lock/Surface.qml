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
    anchors.fill: parent;
    color: Globals.vars.bgDimmedColour;
  }

  Shadow { target: contentBg }

  Rectangle {
    id: contentBg;

    anchors {
      left: parent.left;
      top: parent.top;
      bottom: parent.bottom;
      margins: Globals.vars.gapLarge;
    }
    width: 600;

    border {
      color: Globals.colours.outline;
      width: Globals.vars.outlineSize;
      pixelAligned: false;
    }

    color: Globals.colours.bg;
    radius: Globals.vars.br;

    Item {
      id: content;
      anchors.fill: parent;
      anchors.margins: Globals.vars.paddingWindow;

      ColumnLayout {
        anchors.centerIn: parent;
        width: parent.width;
        spacing: Globals.vars.paddingWindow * 2;

        Clock {}
        PassInput { id: input; pam: pam }
      }

      Status { pam: pam }
    }
  }
}

