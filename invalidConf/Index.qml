pragma ComponentBehavior: Bound

import "root:/";
import "root:/components";
import "root:/utils" as Utils;
import Quickshell;
import QtQuick;
import QtQuick.Layouts;

Loader {
  id: root;
  active: Globals.configValid === Globals.ConfigState.Invalid;
  required property var screen;
  readonly property QtObject colours: Globals.schemes["everforest"];

  sourceComponent: PanelWindow {
    id: window;
    color: Globals.vars.bgDimmedColour;
    screen: root.screen;

    exclusionMode: ExclusionMode.Ignore;

    mask: Region { item: popup }  // Allow clicking through background

    anchors {
      top: true;
      bottom: true;
      left: true;
      right: true;
    }

    Rectangle {
      id: popup;
      color: root.colours.bg;
      width: column.width + Globals.vars.paddingCard * 2;
      height: column.height + Globals.vars.paddingCard * 2;
      anchors.centerIn: parent;
      radius: Globals.vars.br;

      border {
        color: root.colours.outline;
        width: Globals.vars.outlineSize;
        pixelAligned: false;
      }

      ColumnLayout {
        id: column;
        anchors.centerIn: parent;
        spacing: Globals.vars.marginCard;

        Icon {
          Layout.alignment: Qt.AlignHCenter;
          isMask: false;
          icon: "dialog-error";
          size: 64;
        }

        Item {}  // Extra spacing

        Text {
          Layout.alignment: Qt.AlignHCenter;
          text: "Invalid Configuration Provided";
          color: root.colours.fg;
          font {
            family: Globals.vars.fontFamily;
            pixelSize: Globals.vars.smallHeadingFontSize;
          }
        }

        Repeater {
          model: Globals.configInvalidReasons;

          delegate: Text {
            required property string modelData;
            Layout.alignment: Qt.AlignHCenter;
            text: modelData;
            color: root.colours.grey;
            font {
              family: Globals.vars.fontFamily;
              pixelSize: Globals.vars.mainFontSize;
            }
          }
        }

        Button {
          tlRadius: true; trRadius: true; blRadius: true; brRadius: true;
          label: "Quit";
          autoImplicitHeight: true;
          Layout.fillWidth: true;
          labelColour: root.colours.fg;
          bg: root.colours.bgLight;
          bgHover: root.colours.bgHover;
          bgPress: root.colours.accent;

          onClicked: {
            Utils.Validate.exit();
          }
        }
      }
    }
  }
}
