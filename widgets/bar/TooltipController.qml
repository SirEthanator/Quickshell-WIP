pragma Singleton

import qs.widgets.sidebar as Sidebar;
import Quickshell;
import QtQuick;

Singleton {
  id: root;

  property Tooltip activeTooltip: null;
  property var activeModule: null;
  property bool tooltipHovered: false;

  readonly property alias activeTooltipHeight: internal.currentHeight;
  readonly property alias activeTooltipWidth: internal.currentWidth;

  QtObject {
    id: internal;

    property Tooltip previousTooltip: null;
    property int currentHeight: 0;
    property int currentWidth: 0;
  }

  function clearTooltip() {
    activeTooltip = null;
    activeModule = null;
  }

  onActiveTooltipChanged: {
    if (activeTooltip === null) return;

    // Close the sidebar when a menu is opened
    if (activeTooltip?.isMenu) {
      Sidebar.Controller.deactivateAll();
    }

    internal.currentHeight = Qt.binding(() => activeTooltip.height)
    internal.currentWidth = Qt.binding(() => activeTooltip.width)

    if (internal.previousTooltip === null) {
      internal.previousTooltip = activeTooltip;
      return;
    }

    internal.previousTooltip.visible = false;
    activeTooltip.visible = true;

    internal.previousTooltip = activeTooltip;
  }
}
