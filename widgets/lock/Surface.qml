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
      from: Globals.conf.lock.noFade ? 1 : 0;
      to: 1;
      duration: Globals.vars.animLen;
    }
    Anims.Slide {
      target: contentWrapper;
      grow: true;
      slideOffset: 200;
    }
    Anims.Slide {
      target: mediaWrapper;
      originalPos: mediaWrapper.xPos;
      direction: Anims.Slide.Direction.Left;
    }
  }

  ParallelAnimation {
    id: outAnim;
    Anims.NumberAnim {
      target: wallpaper;
      property: "opacity";
      from: 1;
      to: Globals.conf.lock.noFade ? 1 : 0;
      duration: Globals.vars.animLen;
    }
    Anims.Slide {
      target: contentWrapper;
      reverse: true;
    }
    Anims.Slide {
      target: mediaWrapper;
      originalPos: mediaWrapper.xPos;
      direction: Anims.Slide.Direction.Left;
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

  Item {
    id: mediaWrapper;

    height: 200;
    width: 500;

    readonly property real xPos: parent.width - width - Globals.vars.gapLarge;
    readonly property real yPos: parent.height - height - Globals.vars.gapLarge;
    x: xPos;
    y: yPos;

    visible: Utils.Mpris.activePlayer !== null;

    Shadow { target: media }
    Media { id: media }
  }

  // Unlock button for debugging
  // Button {
  //   onClicked: root.beginUnlock();
  //   label: "Unlock"
  // }
}

