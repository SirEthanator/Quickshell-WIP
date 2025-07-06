import "root:/";
import "root:/components";
import QtQuick;
import QtQuick.Layouts;

Rectangle {
  id: root;

  required property var controller;

  Layout.fillHeight: true;
  implicitWidth: 250 + Globals.vars.outlineSize;

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
      margins: Globals.vars.paddingWindow;
    }
    spacing: Globals.vars.spacingButtonGroup;

    Repeater {
      id: itemRepeater;
      model: Globals.conf.getCategories();
      delegate: Button {
        required property Config modelData;
        required property int index;
        label: modelData.category;

        active: modelData === root.controller.currentPage;

        Layout.fillWidth: true;
        autoImplicitHeight: true;

        tlRadius: index === 0; trRadius: tlRadius;
        blRadius: index === itemRepeater.model.length - 1; brRadius: blRadius;
        bg: Globals.colours.bg;

        onClicked: root.controller.currentPage = modelData;

        centreLabel: false;
      }
    }
  }
}

