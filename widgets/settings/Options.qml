pragma ComponentBehavior: Bound

import qs.singletons
import qs.widgets.settings // For LSP
import QtQuick;
import QtQuick.Layouts;

Item {
  id: root;

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
    model: Object.keys(Conf.metadata[Controller.currentPage]);

    delegate: ColumnLayout {
      id: sectionColumn;
      required property string modelData;

      readonly property var sectionMeta: Conf.metadata[Controller.currentPage][sectionColumn.modelData];

      spacing: Consts.spacingButtonGroup;

      width: parent.width;

      function getIsVisible() {
        return typeof sectionMeta._getIsVisible === "function" ? sectionMeta._getIsVisible() : true;
      }

      visible: getIsVisible();

      Connections {
        target: Controller;

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
          propName: modelData;
          section: sectionColumn.modelData;
          page: Controller.currentPage;
        }
      }
    }
  }
}

