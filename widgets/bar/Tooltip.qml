pragma ComponentBehavior: Bound

import "root:/";
import "root:/animations" as Anims;
import "root:/utils" as Utils;
import Quickshell;
import QtQuick;

Scope {
  id: root;

  required property var window;
  property TooltipItem currentItem: null;
  property BarModule module: null;
  property bool open: false;

  property bool animatingIn: true;
  property bool animatingOut: false;

  readonly property int hideTimeout: 500;
  readonly property int showTimeout: 100;

  property var hideTimer: null;
  property var showTimer: null;

  function setTooltip(i, m) {
    // For handling animations being interrupted
    if (animatingOut) {
      animatingOut = false;
      animatingIn = true;
    }

    if (hideTimer !== null) {
      hideTimer.destroy();
      hideTimer = null;
    } else {
      showTimer = Utils.Timeout.setTimeout(() => {
        animatingIn = true;
        currentItem = i;
        module = m;
        open = true;
      }, showTimeout);
    }
  }

  function removeTooltip() {
    if (showTimer !== null) {
      showTimer.destroy();
      showTimer = null;
    } else {
      hideTimer = Utils.Timeout.setTimeout(() => {
        animatingIn = false;
        animatingOut = true;
      }, hideTimeout);
    }
  }

  onOpenChanged: {
    if (open) loader.activeAsync = true;
    else {
      currentItem = null;
      module = null;
      loader.activeAsync = false;
    }
  }

  LazyLoader {
    id: loader;

    activeAsync: false;

    PopupWindow {
      id: popup;
      visible: root.open;

      anchor {
        window: root.window;
        rect.y: root.window.height;
        edges: Edges.Top;
        gravity: Edges.Bottom;
        onAnchoring: {
          popup.anchor.rect.x = popup.anchor.window.contentItem.mapFromItem(root.module, root.module.width / 2, 0).x;
        }
      }

      color: "transparent";
      implicitWidth: bg.width;
      implicitHeight: bg.height + Globals.vars.gapLarge;

      readonly property int slideOffset: Globals.vars.gapLarge;

      Anims.SlideFade {
        running: root.animatingIn;
        target: bg;
        direction: "down";
        slideOffset: popup.slideOffset;
        originalPos: Globals.vars.gapLarge;
      }

      SequentialAnimation {
        id: outAnim;
        running: root.animatingOut;
        Anims.SlideFade {
          target: bg;
          direction: "down";
          slideOffset: popup.slideOffset;
          originalPos: Globals.vars.gapLarge;
          reverse: true;
        }
        PropertyAction { target: root; property: "open"; value: false }
      }

      Rectangle {
        id: bg;

        y: Globals.vars.gapLarge;
        width: content.width + Globals.vars.paddingModule * 2;
        height: content.height + Globals.vars.paddingModule * 2;

        color: Globals.colours.bg;
        radius: Globals.vars.br;
        border {
          color: Globals.colours.outline;
          width: Globals.vars.outlineSize;
          pixelAligned: false;
        }

        Item {
          id: content;
          anchors.centerIn: parent;
          width: root.currentItem.width;
          height: root.currentItem.height;

          Component.onCompleted: {
            root.currentItem.parent = this;
          }
        }
      }
    }
  }
}
