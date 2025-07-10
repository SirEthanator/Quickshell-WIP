pragma ComponentBehavior: Bound

import "root:/";
import "root:/animations" as Anims;
import Quickshell;
import QtQuick;
import QtQuick.Layouts;

ColumnLayout {
  id: root;
  spacing: Globals.vars.paddingCard;

  required property var controller;
  required property string propName;
  required property string page;
  required property list<string> options;

  width: parent.width;

  // property list<string> currentVal: controller.getVal(page, propName);
  property ScriptModel currentVal: ScriptModel {
    values: root.controller.getVal(root.page, root.propName)

    onValuesChanged: {
      if (root.completed)
        root.controller.changeVal(root.page, root.propName, values);
    }
  }

  QtObject {
    id: internal;
    property bool completed: false;
  }
  Component.onCompleted: internal.completed = true;
  readonly property bool completed: internal.completed;

  // BUTTONS HERE

  ListView {
    id: list;

    model: root.currentVal;
    implicitHeight: contentHeight;
    implicitWidth: parent.width;

    interactive: false;
    clip: true;

    spacing: Globals.vars.marginCard;

    add: Transition {
      NumberAnimation { property: "opacity"; from: 0; to: 1; duration: Globals.vars.shortTransitionLen }
    }
    displaced: Transition {
      NumberAnimation { property: "y"; duration: Globals.vars.transitionLen; easing.type: Easing.OutCubic }
    }
    move: Transition {
      NumberAnimation { property: "y"; duration: Globals.vars.transitionLen; easing.type: Easing.OutCubic }
    }
    remove: Transition {
      NumberAnimation { property: "opacity"; from: 1; to: 0; duration: Globals.vars.shortTransitionLen }
    }

    delegate: MouseArea {
      id: delegate;
      required property string modelData;
      required property int index;

      width: parent.width;
      height: delegateBg.height;

      cursorShape: containsPress ? Qt.DragMoveCursor : Qt.ArrowCursor;

      drag.target: delegate;
      drag.axis: Drag.YAxis;

      property double originalY: y;
      onPressed: originalY = y;

      z: containsPress ? 100 : 0;

      function swap(arr, a, b) {
        let result = [...arr];
        result[a] = arr[b];
        result[b] = arr[a];
        return result;
      }

      onReleased: {
        // TODO: Allow for moving by more than one place
        // TODO: Move while dragging, not on release
        const deltaY = y - originalY;
        if (deltaY < 0) {
          if (index > 0 && -deltaY > height/2) {
            root.currentVal.values = swap(root.currentVal.values, index, index-1);
          }
        } else {
          if (index < list.model.values.length-1 && deltaY > height/2) {
            root.currentVal.values = swap(root.currentVal.values, index, index+1);
          }
        }

        y = originalY;
      }

      Anims.NumberTransition on y {}

      Rectangle {
        id: delegateBg;
        height: delegateRow.height + Globals.vars.paddingCard * 2;
        width: parent.width;

        color: Globals.colours.bg;
        radius: Globals.vars.br;

        RowLayout {
          id: delegateRow;
          spacing: Globals.vars.paddingCard;
          Layout.maximumWidth: parent.width - Globals.vars.paddingCard * 2;

          anchors {
            left: parent.left;
            top: parent.top;
            margins: Globals.vars.paddingCard;
          }

          // Drag indicator
          RowLayout {
            spacing: 4;
            Rectangle { implicitWidth: 2; implicitHeight: 30; color: Globals.colours.outline }
            Rectangle { implicitWidth: 2; implicitHeight: 30; color: Globals.colours.outline }
          }

          Text {
            text: delegate.modelData;
            color: Globals.colours.fg;
            font {
              family: Globals.vars.fontFamily;
              pixelSize: Globals.vars.smallHeadingFontSize;
            }
            maximumLineCount: 1;
            elide: Text.ElideRight;
          }
        }
      }
    }
  }
}

