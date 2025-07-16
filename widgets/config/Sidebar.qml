import qs
import qs.components
import QtQuick;
import QtQuick.Layouts;

Rectangle {
  id: root;

  required property var controller;

  Layout.fillHeight: true;
  implicitWidth: 250;

  color: Globals.colours.bgLight;

  // Text {
  //   id: title;
  //
  //   text: "Config";  // Placeholder
  //
  //   anchors.top: parent.top;
  //   anchors.left: parent.left;
  //   anchors.margins: Globals.vars.paddingWindow;
  //
  //   font {
  //     family: Globals.vars.fontFamily;
  //     pixelSize: Globals.vars.headingFontSize;
  //   }
  //   color: Globals.colours.fg;
  // }

  ColumnLayout {
    id: items;
    anchors {
      // top: title.bottom;
      top: root.top;
      left: parent.left;
      right: parent.right;
      bottom: parent.bottom;
      margins: Globals.vars.paddingWindow;
    }
    spacing: Globals.vars.spacingButtonGroup;

    Repeater {
      id: itemRepeater;
      model: Globals.conf.getCategoryKeys();
      delegate: Button {
        required property string modelData;
        required property int index;
        label: Globals.conf[modelData].category;

        active: modelData === root.controller.currentPage;

        Layout.fillWidth: true;

        tlRadius: index === 0; trRadius: tlRadius;
        blRadius: index === itemRepeater.model.length - 1; brRadius: blRadius;
        bg: Globals.colours.bg;

        onClicked: root.controller.currentPage = modelData;

        centreLabel: false;
      }
    }

    Item { Layout.fillHeight: true }

    Button {
      Layout.fillWidth: true;

      property int changeCount: root.controller.changeCount;
      visible: changeCount > 0;

      icon: "filesave-symbolic";
      label: `Apply ${changeCount}`;

      bg: Globals.colours.accent;
      bgHover: Globals.colours.accentLight;
      labelColour: Globals.colours.bgLight;
      invertTextOnPress: false;
      allRadius: true;

      onClicked: root.controller.apply();
    }
  }
}

