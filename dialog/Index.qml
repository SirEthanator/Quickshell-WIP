pragma ComponentBehavior: Bound

import "root:/";
import Quickshell;
import Quickshell.Wayland;
import QtQuick;
import QtQuick.Layouts;
import QtQuick.Controls;

PanelWindow {
  id: root;
  required screen;

  property string title: "test";
  property string text: "test";
  property var actions;

  color: Qt.rgba(0, 0, 0, 0.55)

  anchors {
    top: true;
    bottom: true;
    left: true;
    right: true;
  }

  focusable: true;

  exclusionMode: ExclusionMode.Ignore;
  WlrLayershell.layer: WlrLayer.Overlay;
  WlrLayershell.keyboardFocus: WlrKeyboardFocus.Exclusive;

  Item {
    anchors.fill: parent;
    focus: true;

    Keys.onEscapePressed: {
      root.destroy();
    }

    Rectangle {
      anchors.centerIn: parent;
      color: Globals.colours.bg;
      radius: Globals.vars.br;
      width: content.width + Globals.vars.paddingCard;
      height: content.height + Globals.vars.paddingCard;

      ColumnLayout {
        id: content;
        anchors.centerIn: parent;

        Text {
          text: root.title;
          color: Globals.colours.fg;
          font: Globals.vars.headingFontSmall;
        }

        Text {
          text: root.text;
          color: Globals.colours.fg;
          font: Globals.vars.mainFont;
        }

        RowLayout {
          spacing: Globals.vars.spacingButtonGroup;
          uniformCellSizes: true;

          Repeater {
            model: root.actions;

            Button {
              id: actionBtn;
              required property var modelData;
              required property int index;
              Layout.fillWidth: true;

              background: Rectangle {
                color: Globals.colours.bgLight;
                topLeftRadius: actionBtn.index === 0 ? Globals.vars.br : 0;
                bottomLeftRadius: actionBtn.index === 0 ? Globals.vars.br : 0;
                topRightRadius: actionBtn.index === root.actions.length ? Globals.vars.br : 0;
                bottomRightRadius: actionBtn.index === root.actions.length ? Globals.vars.br : 0;
              }

              text: modelData.name;
              contentItem: Text {
                text: actionBtn.text
              }
            }
          }
        }
      }
    }
  }
}

