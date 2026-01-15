pragma ComponentBehavior: Bound

import qs
import qs.animations as Anims;
import qs.components
import Quickshell;
import Quickshell.Services.SystemTray;
import QtQuick;
import QtQuick.Layouts;

BarModule {
  id: root;
  required property var window;
  readonly property int slideOffset: Globals.vars.gapLarge + 10;

  hoverEnabled: true;
  background: mouseArea.containsPress ? Globals.colours.accent : mouseArea.containsMouse ? Globals.colours.bgHover : Globals.colours.bgLight;
  onClicked: event => {
    popupLoader.open = !popupLoader.open;
  }

  Icon {
    icon: "expand-symbolic";
    color: root.mouseArea.containsPress ? Globals.colours.bgLight : Globals.colours.fg;
    rotation: popupLoader.open ? 180 : 0;
  }

  visible: SystemTray.items.values.length > 0;

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
        rect.y: root.window.height;
        edges: Edges.Top;
        gravity: Edges.Bottom;
        onAnchoring: {
          popup.anchor.rect.x = popup.anchor.window.contentItem.mapFromItem(root, root.width / 2, 0).x;
        }
      }
      visible: true;
      color: "transparent";

      width: bg.width;
      height: bg.height + Globals.vars.gapLarge;

      grabFocus: true;

      onVisibleChanged: {
        if (!visible) {
          popupLoader.open = false;
          popupLoader.active = false;
        }
      }

      Rectangle {
        id: bg;
        width: trayButtons.width + Globals.vars.paddingWindow * 2;
        height: trayButtons.height + Globals.vars.paddingWindow * 2;
        y: Globals.vars.gapLarge;
        color: Globals.colours.bg;
        radius: Globals.vars.br;

        Anims.Slide {
          running: popupLoader.open;
          target: bg;
          direction: Anims.Slide.Direction.Down;
          slideOffset: root.slideOffset;
          originalPos: Globals.vars.gapLarge;
          grow: true;
        }

        SequentialAnimation {
          running: !popupLoader.open && popup.visible;
          Anims.Slide {
            target: bg;
            direction: Anims.Slide.Direction.Down;
            slideOffset: root.slideOffset;
            originalPos: Globals.vars.gapLarge;
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

          TrayItems {
            window: popup;
            onActivated: popupLoader.open = false;
          }
        }
      }

    }
  }
}

