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

    spacing: Globals.vars.paddingWindow;
    clip: true;

    boundsBehavior: dragging ? Flickable.DragAndOvershootBounds : Flickable.StopAtBounds;
    model: Object.keys(Conf.metadata[root.controller.currentPage]);

    delegate: ColumnLayout {
      id: sectionColumn;
      required property string modelData;

      spacing: Globals.vars.spacingButtonGroup;

      width: parent.width;

      Text {
        text: sectionColumn.modelData;
        font {
          family: Globals.vars.fontFamily;
          pixelSize: Globals.vars.mediumHeadingFontSize;
          variableAxes: {
            "wght": 550
          }
        }
        color: Globals.colours.fg;
      }

      Item { implicitHeight: Globals.vars.marginCardSmall - sectionColumn.spacing }

      Repeater {
        id: sectionItems;
        model: Object.keys(Conf.metadata[root.controller.currentPage][sectionColumn.modelData]);
        delegate: Option {
          required property string modelData;
          modelLen: sectionItems.model.length;
          controller: root.controller;
          propName: modelData;
          section: sectionColumn.modelData;
          page: root.controller.currentPage;
        }
      }
    }
  }
}

