pragma ComponentBehavior: Bound

import qs.singletons
import qs.components
import qs.panels.settings // For LSP
import QtQuick;
import QtQuick.Layouts;

Rectangle {
  id: root;

  Layout.fillHeight: true;
  implicitWidth: 250;

  color: Colors.c.bgLight;

  Text {
    id: title;

    text: "Settings";

    anchors {
      top: parent.top;
      left: parent.left;
      margins: Consts.paddingWindow;
      leftMargin: Consts.paddingWindow + Consts.paddingButton;
    }

    font {
      family: Consts.fontFamily;
      pixelSize: Consts.headingFontSize;
      variableAxes: {
        "wght": 650
      }
    }
    color: Colors.c.fg;
  }

  ColumnLayout {
    id: items;
    anchors {
      top: title.bottom;
      // top: root.top;
      left: parent.left;
      right: parent.right;
      bottom: parent.bottom;
      margins: Consts.paddingWindow;
    }
    spacing: Consts.spacingButtonGroup;

    Repeater {
      id: itemRepeater;
      model: Conf.getCategoryKeys();
      delegate: Button {
        required property string modelData;
        required property int index;
        label: Conf[modelData].category;

        active: modelData === Controller.currentPage;

        Layout.fillWidth: true;

        tlRadius: index === 0; trRadius: tlRadius;
        blRadius: index === itemRepeater.model.length - 1; brRadius: blRadius;
        bg: Colors.c.bg;

        onClicked: Controller.currentPage = modelData;

        centreLabel: false;
      }
    }

    Item { Layout.fillHeight: true }

    Button {
      Layout.fillWidth: true;

      property int changeCount: Controller.changeCount;
      visible: changeCount > 0;

      icon: "filesave-symbolic";
      label: `Apply ${changeCount}`;

      bg: Colors.c.accent;
      bgHover: Colors.c.accentLight;
      labelColor: Colors.c.bgLight;
      invertTextOnPress: false;
      allRadius: true;

      onClicked: Controller.apply();
    }
  }
}

