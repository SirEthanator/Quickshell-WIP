import qs.singletons
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
    Utils.Timeout.setTimeout(lock.unlock, Consts.animLen);
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
    visible: Conf.lock.dimBackground;
    color: Consts.bgDimmedColour;
  }

  ParallelAnimation {
    running: true;
    Anims.NumberAnim {
      target: wallpaper;
      property: "opacity";
      from: Conf.lock.noFade ? 1 : 0;
      to: 1;
      duration: Consts.animLen;
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
      to: Conf.lock.noFade ? 1 : 0;
      duration: Consts.animLen;
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
    width: Conf.sidebar.width;

    Shadow { target: contentBg }

    Rectangle {
      id: contentBg;
      anchors.fill: parent;
      anchors.margins: Consts.gapLarge;

      border {
        color: Globals.colours.outline;
        width: Conf.lock.contentOutline ? Consts.outlineSize : 0;
        pixelAligned: false;
      }

      color: Globals.colours.bg;
      radius: Consts.br;
    }

    Item {
      id: content;
      anchors.fill: contentBg;
      anchors.margins: Consts.paddingWindow;

      ColumnLayout {
        anchors.centerIn: parent;
        width: parent.width;
        spacing: Consts.paddingWindow * 2;

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

    readonly property real xPos: parent.width - width - Consts.gapLarge;
    readonly property real yPos: parent.height - height - Consts.gapLarge;
    x: xPos;
    y: yPos;

    visible: Utils.Mpris.activePlayer !== null;

    Shadow { target: media }
    Media {
      id: media;
      anchors.fill: parent;
    }
  }

  // Unlock button for debugging
  // Button {
  //   onClicked: root.beginUnlock();
  //   label: "Unlock"
  // }
}
