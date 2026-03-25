import qs.singletons
import qs.components
import qs.widgets.screensaver as ScreensaverWidget
import qs.panels.screensaver as Screensaver
import qs.widgets.media as Media
import qs.animations as Anims
import qs.utils as Utils
import qs.panels.desktop as Desktop
import Quickshell.Wayland
import QtQuick
import QtQuick.Layouts

WlSessionLockSurface {
  id: root;

  required property WlSessionLock lock;

  color: "transparent";

  function beginUnlock() {
    outAnim.start();
    Utils.Timeout.setTimeout(lock.unlock, Consts.animLenMain);
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
    color: Colors.c.backdrop;
  }

  ParallelAnimation {
    running: true;
    Anims.NumberAnim {
      target: wallpaper;
      property: "opacity";
      from: Conf.lock.noFade ? 1 : 0;
      to: 1;
      duration: Consts.animLenMain;
    }
    Anims.Slide {
      target: contentWrapper;
      grow: true;
      slideOffset: 200;
    }
    // FIXME: Media sometimes disappears soon after animation starts?
    // Seems to usually happen when a notification popup is currently displaying (not consistent).
    // Also occurs seemingly randomly.
    Anims.Slide {
      target: mediaWrapper;
      originalPos: mediaWrapper.yPos;
      direction: Anims.Slide.Direction.Up;
    }
    Anims.Slide {
      target: notifCount;
      originalPos: notifCount.yPos;
      direction: Anims.Slide.Direction.Down;
    }
  }

  ParallelAnimation {
    id: outAnim;
    Anims.NumberAnim {
      target: wallpaper;
      property: "opacity";
      from: 1;
      to: Conf.lock.noFade ? 1 : 0;
      duration: Consts.animLenMain;
    }
    Anims.Slide {
      target: contentWrapper;
      reverse: true;
    }
    Anims.Slide {
      target: mediaWrapper;
      originalPos: mediaWrapper.yPos;
      direction: Anims.Slide.Direction.Up;
      reverse: true;
    }
    Anims.Slide {
      target: notifCount;
      originalPos: notifCount.yPos;
      direction: Anims.Slide.Direction.Down;
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
        color: Colors.c.outline;
        width: Conf.lock.contentOutline ? Consts.outlineSize : 0;
        pixelAligned: false;
      }

      color: Colors.c.bg;
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
        PassInput {
          id: input;
          pam: pam;
          onChange: Screensaver.Controller.open = false;
          Keys.onPressed: Screensaver.Controller.open = false;
        }
      }

      Status { pam: pam }
    }
  }

  NotifCount {
    id: notifCount;

    readonly property real xPos: parent.width - width - Consts.gapLarge;
    readonly property real yPos: Consts.gapLarge;
    x: xPos;
    y: yPos;
  }

  Item {
    id: mediaWrapper;

    height: media.implicitHeight;
    width: media.implicitWidth;

    readonly property real xPos: parent.width - width - Consts.gapLarge;
    readonly property real yPos: parent.height - height - Consts.gapLarge;
    x: xPos;
    y: yPos;

    visible: Utils.Mpris.activePlayer !== null;

    Shadow { target: media }
    Media.Index { id: media }
  }

  Loader {
    anchors.fill: parent;
    active: Screensaver.Controller.open;

    sourceComponent: Item {
      anchors.fill: parent;

      ScreensaverWidget.Index {
        anchors.fill: parent;
      }
    }
  }
}
