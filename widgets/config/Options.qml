pragma ComponentBehavior: Bound

import "root:/";
import QtQuick;
import QtQuick.Layouts;

Item {
  id: root;

  required property var controller;
  Layout.fillWidth: true;
  Layout.fillHeight: true;

  ListView {
    id: items;

    anchors {
      top: parent.top;
      left: parent.left;
      right: parent.right;
      bottom: parent.bottom;
      margins: Globals.vars.paddingWindow;
    }

    spacing: Globals.vars.spacingButtonGroup;
    clip: true;

    model: root.controller.currentPage.getProperties();

    delegate: Option {
      required property var modelData;
      modelLen: items.model.length;
      propName: modelData;
      page: root.controller.currentPage;
      propValue: root.controller.currentPage[modelData];
      metadata: root.controller.currentPage.getMetadata(modelData);
    }
  }
}

