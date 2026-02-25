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
    // Subtract gap if autohiding to remove extra space for hover area
    rect.y: root.window.height - (Conf.bar.autohide ? Consts.gap : 0);
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
      if (TooltipController.activeTooltip === null) return;
      TooltipController.activeTooltip.parent = content;
    }

    function onActiveModuleChanged() {
      tooltipMouse.setXPos();
    }

    function onRequestReposition() {
      tooltipMouse.setXPos();
    }
  }

  color: TooltipController?.activeTooltip?.isMenu ? Consts.bgDimmedColour : "transparent";

  Anims.ColourTransition on color { duration: Consts.animLen }

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

    readonly property int whCommon:
      (TooltipController?.activeTooltip.padding ?? NaN)*2
      + (TooltipController?.activeTooltip.disableOutline ? 0 : tooltipBg.outlineSize*2)

    height: whCommon + content.height + Consts.gapSmall;
    width: whCommon + content.width;

    hoverEnabled: true;
    onContainsMouseChanged: {
      TooltipController.tooltipHovered = containsMouse;
    }

    function getXPos() {
      const targetPos = root.window.contentItem.mapFromItem(
        TooltipController.activeModule,
        (TooltipController?.activeModule?.width ?? NaN) / 2,
        0
      ).x - tooltipMouse.width / 2;

      const min = Consts.gapSmall;
      const max = root.window.width - Consts.gapSmall - tooltipMouse.width;

      return Math.min(Math.max(targetPos, min), max);
    }

    function setXPos() {
      x = getXPos()
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

      disableAllOutlines: TooltipController?.activeTooltip.disableOutline;

      Item {
        id: content;
        anchors.centerIn: parent.content;

        height: TooltipController.activeTooltipHeight;
        width: TooltipController.activeTooltipWidth;
      }
    }
  }
}
