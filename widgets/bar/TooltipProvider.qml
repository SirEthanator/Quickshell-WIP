import qs.singletons
import qs.components
import qs.widgets.bar
import qs.animations as Anims;
import Quickshell;
import QtQuick;

PopupWindow {
  id: root;
  default property alias data: content.data;

  required property var window;

  anchor {
    window: root.window;
    rect.y: root.window.height;
    edges: Edges.Top;
    gravity: Edges.Bottom;
  }

  property bool open: TooltipController.activeTooltip !== null && TooltipController.activeModule !== null;
  visible: false;

  onOpenChanged: {
    if (open) {
      visible = true;
      outAnim.stop();
      inAnim.restart();
    } else {
      outAnim.restart();
    }
  }

  Anims.Slide {
    id: inAnim;
    target: tooltipMouse;
    slideOffset: Consts.gapSmall;
    direction: Anims.Slide.Direction.Down;
    grow: true;
  }

  SequentialAnimation {
    id: outAnim;

    Anims.Slide {
      target: tooltipMouse;
      slideOffset: Consts.gapSmall;
      direction: Anims.Slide.Direction.Down;
      grow: false;
      reverse: true;
    }

    PropertyAction { property: "visible"; target: root; value: false; }
  }

  Connections {
    target: TooltipController;

    function onActiveTooltipChanged() {
      TooltipController.activeTooltip.parent = content;
    }

    function onActiveModuleChanged() {
      tooltipMouse.x = tooltipMouse.getXPos();
    }
  }

  color: TooltipController?.activeTooltip?.isMenu ? Consts.bgDimmedColour : "transparent";

  Anims.ColourTransition on color {}

  implicitWidth: window.width;
  implicitHeight: window.screen.height - anchor.rect.y;

  mask: Region {
    id: tooltipRegion;

    readonly property bool enabled: !TooltipController?.activeTooltip?.isMenu;
    readonly property bool allowFullClickThrough: !root.open;

    width: allowFullClickThrough ? 0 : enabled ? tooltipMouse.width : root.implicitWidth;
    height: allowFullClickThrough ? 0 : enabled ? tooltipMouse.height : root.implicitHeight;

    x: allowFullClickThrough || !enabled ? 0 : tooltipMouse.x;
  }

  MouseArea {
    anchors.fill: parent;

    onClicked: {
      TooltipController.clearTooltip();
    }
  }

  MouseArea {
    id: tooltipMouse;
    height: content.height + Consts.paddingModule*2 + tooltipBg.outlineSize*2 + Consts.gapSmall;
    width: content.width + Consts.paddingModule*2 + tooltipBg.outlineSize*2;

    hoverEnabled: true;
    onContainsMouseChanged: {
      TooltipController.tooltipHovered = containsMouse;
    }

    function getXPos() {
      return root.window.contentItem.mapFromItem(
        TooltipController.activeModule,
        TooltipController.activeModule.width / 2,
        0
      ).x - width / 2;
    }

    x: getXPos();

    Anims.NumberTransition on x { enabled: root.visible }

    Shadow {
      target: tooltipBg;
      blur: 10;
    }

    OutlinedRectangle {
      id: tooltipBg;
      color: Globals.colours.bg;
      radius: Consts.br;

      height: parent.height - Consts.gapSmall;
      width: parent.width;
      y: Consts.gapSmall;

      Anims.NumberTransition on width { enabled: root.visible }
      Anims.NumberTransition on height { enabled: root.visible }

      Item {
        id: content;
        anchors.centerIn: parent.content;

        height: TooltipController.activeTooltipHeight;
        width: TooltipController.activeTooltipWidth;
      }
    }
  }
}
