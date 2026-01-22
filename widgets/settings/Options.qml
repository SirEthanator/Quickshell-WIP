pragma ComponentBehavior: Bound

import qs.singletons
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
      margins: Consts.paddingWindow;
      horizontalCenter: parent.horizontalCenter;
    }

    width: Math.min(root.maxWidth, root.width - Consts.paddingWindow * 2);

    spacing: Consts.paddingWindow;
    clip: true;

    boundsBehavior: dragging ? Flickable.DragAndOvershootBounds : Flickable.StopAtBounds;
    model: Object.keys(Conf.metadata[root.controller.currentPage]);

    delegate: ColumnLayout {
      id: sectionColumn;
      required property string modelData;

      readonly property var sectionMeta: Conf.metadata[root.controller.currentPage][sectionColumn.modelData];

      spacing: Consts.spacingButtonGroup;

      width: parent.width;

      function getIsVisible() {
        return typeof sectionMeta._getIsVisible === "function" ? sectionMeta._getIsVisible(root.controller.getVal) : true;
      }

      visible: getIsVisible();

      Connections {
        target: root.controller;

        function onDataVersionChanged() {
          sectionColumn.visible = sectionColumn.getIsVisible();
        }
      }

      Text {
        text: sectionColumn.modelData;
        font {
          family: Consts.fontFamily;
          pixelSize: Consts.mediumHeadingFontSize;
          variableAxes: {
            "wght": 550
          }
        }
        color: Globals.colours.fg;
      }

      Item { implicitHeight: Consts.marginCardSmall - sectionColumn.spacing }

      Repeater {
        id: sectionItems;
        model: Object.keys(sectionColumn.sectionMeta).filter((key) => !key.startsWith("_"));
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

