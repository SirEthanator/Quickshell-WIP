pragma ComponentBehavior: Bound

import qs
import QtQuick;
import QtQuick.Layouts;

Item {
  id: root;

  required property var controller;
  Layout.fillWidth: true;
  Layout.fillHeight: true;

  readonly property int maxWidth: 1000;

  ListView {
    id: items;

    anchors {
      top: parent.top;
      bottom: parent.bottom;
      margins: Globals.vars.paddingWindow;
      horizontalCenter: parent.horizontalCenter;
    }

    width: Math.min(root.maxWidth, root.width - Globals.vars.paddingWindow * 2);

    spacing: Globals.vars.spacingButtonGroup;
    clip: true;

    boundsBehavior: dragging ? Flickable.DragAndOvershootBounds : Flickable.StopAtBounds;
    model: Conf[root.controller.currentPage].getProperties();

    delegate: Option {
      required property string modelData;
      modelLen: items.model.length;
      controller: root.controller
      propName: modelData;
      page: root.controller.currentPage;
    }
  }
}

