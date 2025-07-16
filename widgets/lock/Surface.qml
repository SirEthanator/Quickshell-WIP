import qs
import qs.components
import qs.animations as Anims;
import qs.utils as Utils;
import qs.widgets.desktop as Desktop;
import Quickshell.Wayland;
import QtQuick;
import QtQuick.Layouts;

WlSessionLockSurface {
  id: root;

  required property WlSessionLock lock;

  color: "transparent";

  function beginUnlock() {
    outAnim.start();
    Utils.Timeout.setTimeout(lock.unlock, Globals.vars.animLen);
  }

  Pam {
    id: pam;
    lock: root.lock;
    surface: root;
    onPasswordChanged: {
      if (password !== input.field.text) input.field.text = password;
    }
  }

  Desktop.Wallpaper { id: wallpaper }

  Rectangle {
    anchors.fill: parent;
    visible: Globals.conf.lock.dimBackground;
    color: Globals.vars.bgDimmedColour;
  }

  ParallelAnimation {
    running: true;
    Anims.NumberAnim {
      target: wallpaper;
      property: "opacity";
      from: 0; to: 1;
      duration: Globals.vars.animLen;
    }
    Anims.SlideFade {
      target: contentWrapper;
    }
  }

  ParallelAnimation {
    id: outAnim;
    Anims.NumberAnim {
      target: wallpaper;
      property: "opacity";
      from: 1; to: 0;
      duration: Globals.vars.animLen;
    }
    Anims.SlideFade {
      target: contentWrapper;
      reverse: true;
    }
  }

  Item {
    id: contentWrapper;

    height: parent.height;
    width: 600;

    Shadow { target: contentBg }

    Rectangle {
      id: contentBg;
      anchors.fill: parent;
      anchors.margins: Globals.vars.gapLarge;

      border {
        color: Globals.colours.outline;
        width: Globals.conf.lock.contentOutline ? Globals.vars.outlineSize : 0;
        pixelAligned: false;
      }

      color: Globals.colours.bg;
      radius: Globals.vars.br;
    }

    Item {
      id: content;
      anchors.fill: contentBg;
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

