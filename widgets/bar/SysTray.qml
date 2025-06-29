pragma ComponentBehavior: Bound

import "root:/";
import "root:/animations" as Anims;
import "root:/components";
import Quickshell;
import QtQuick;
import QtQuick.Layouts;

BarModule {
  id: root;
  required property var window;
  readonly property int slideOffset: 20;

  hoverEnabled: true;
  background: mouseArea.containsPress ? Globals.colours.accent : mouseArea.containsMouse ? Globals.colours.bgHover : Globals.colours.bgLight;
  onClicked: event => {
    popupLoader.open = !popupLoader.open;
  }

  Icon {
    icon: "expand-symbolic";
    colour: root.mouseArea.containsPress ? Globals.colours.bgLight : Globals.colours.fg;
    rotation: popupLoader.open ? 180 : 0;
  }

  LazyLoader {
    id: popupLoader;
    property bool open: false;
    active: false;

    onOpenChanged: {
      if (open) active = true;
    }

    PopupWindow {
      id: popup;

      anchor {
        window: root.window;
        rect.y: root.window.height + Globals.vars.gapLarge;
        edges: Edges.Top;
        gravity: Edges.Bottom;
        onAnchoring: {
          popup.anchor.rect.x = popup.anchor.window.contentItem.mapFromItem(root, root.width / 2, 0).x;
        }
      }
      visible: true;
      color: "transparent";

      width: bg.width;
      height: bg.height;

      Rectangle {
        id: bg;
        width: trayButtons.width + Globals.vars.paddingWindow * 2;
        height: trayButtons.height + Globals.vars.paddingWindow * 2;
        color: Globals.colours.bg;
        radius: Globals.vars.br;

        Anims.SlideFade {
          running: popupLoader.open;
          target: bg;
          direction: "down";
          slideOffset: root.slideOffset;
        }

        SequentialAnimation {
          running: !popupLoader.open;
          Anims.SlideFade {
            target: bg;
            direction: "down";
            slideOffset: root.slideOffset;
            reverse: true;
          }
          PropertyAction { property: "active"; target: popupLoader; value: false }
        }

        border {
          color: Globals.colours.outline;
          width: Globals.vars.outlineSize;
          pixelAligned: false;
        }

        GridLayout {
          id: trayButtons;
          columns: 5;
          rowSpacing: Globals.vars.marginCard;
          columnSpacing: Globals.vars.marginCard;
          anchors.centerIn: parent;

          TrayItems { window: popup }
        }
      }

    }
  }
}

