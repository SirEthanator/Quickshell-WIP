pragma ComponentBehavior: Bound

import "root:/";
import Quickshell;
import QtQuick;

Scope {
  id: root;

  required property var window;
  property TooltipItem currentItem: null;
  property BarModule module: null;
  property bool open: currentItem !== null && module !== null;

  function setTooltip(i, m) {
    currentItem = i;
    module = m;
  }

  function removeTooltip() {
    currentItem = null;
    module = null;
  }

  LazyLoader {
    id: loader;

    activeAsync: root.open;

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
