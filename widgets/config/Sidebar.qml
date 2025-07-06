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
        autoImplicitHeight: true;

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
      autoImplicitHeight: true;

      property int changeCount: root.controller.changeCount;
      visible: changeCount > 0;

      label: `Apply ${changeCount}`;

      bg: Globals.colours.accent;
      bgHover: Globals.colours.accentLight;
      labelColour: Globals.colours.bgLight;
      invertTextOnPress: false;

      tlRadius: true; trRadius: true; blRadius: true; brRadius: true;

      onClicked: root.controller.apply();
    }
  }
}

