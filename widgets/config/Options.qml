import "root:/";
import QtQuick;
import QtQuick.Layouts;
import QtCore;

Item {
  id: root;

  required property var controller;
  Layout.fillWidth: true;
  Layout.fillHeight: true;

  ColumnLayout {
    id: items;

    spacing: Globals.vars.spacingButtonGroup;

    Repeater {
      model: root.controller.currentPage.getProperties();

      delegate: Text {
        required property var modelData;
        text: modelData;
      }
    }
  }
}

