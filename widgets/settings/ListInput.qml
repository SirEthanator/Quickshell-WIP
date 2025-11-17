pragma ComponentBehavior: Bound

import qs
import qs.components
import qs.animations as Anims;
import Quickshell;
import QtQuick;
import QtQuick.Layouts;

ColumnLayout {
  id: root;
  spacing: Globals.vars.marginCard;

  required property var controller;
  required property string propName;
  required property string page;
  required property var options;

  readonly property bool popupOpen: addPopup.visible;

  QtObject {
    id: internal;
    property bool completed: false;
  }
  Component.onCompleted: internal.completed = true;
  readonly property bool completed: internal.completed;

  width: parent.width;

  // property list<string> currentVal: controller.getVal(page, propName);
  property ScriptModel currentVal: ScriptModel {
    values: root.controller.getVal(root.page, root.propName)

    onValuesChanged: {
      if (root.completed)
        root.controller.changeVal(root.page, root.propName, values);
    }
  }

  onImplicitHeightChanged: height = implicitHeight;

  Anims.NumberTransition on height { enabled: completed }

  RowLayout {
    id: buttons;
    spacing: Globals.vars.marginCardSmall;

    z: 1000;  // For the add popup to show on top of options

    Button {
      id: addButton;

      label: "Add New";
      allRadius: true;

      onClicked: addPopup.toggle();

      Rectangle {
        id: addPopup;

        anchors.top: parent.bottom;
        anchors.margins: Globals.vars.marginCard;

        height: addPopupItems.contentHeight;
        width: 200;

        color: Globals.colours.bg;

        visible: false;
        function toggle() { visible=!visible; if (visible) forceActiveFocus() }
        function open() { visible=true; forceActiveFocus() }
        function close() { visible=false }

        onActiveFocusChanged: if (!activeFocus) close();

        Border {
          setParentRadius: true;
        }

        ListView {
          id: addPopupItems;
          anchors.fill: parent;

          model: Object.keys(root.options);

          delegate: Button {
            required property string modelData;
            label: root.options[modelData].title;

            height: implicitHeight;
            anchors.right: parent.right;
            anchors.left: parent.left;

            radiusValue: addPopup.topLeftRadius;  // Any of the popup's radii except for radius itself are set by the border and are equal
            allRadius: true;

            onClicked: {
              root.currentVal.values.push(modelData);
              addPopup.close();
            }
          }
        }
      }
    }
  }

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
      PropertyAction { property: "opacity"; value: 1 }
    }
    move: Transition {
      NumberAnimation { property: "y"; duration: Globals.vars.transitionLen; easing.type: Easing.OutCubic }
      PropertyAction { property: "opacity"; value: 1 }
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

      cursorShape: drag.active ? Qt.DragMoveCursor : Qt.ArrowCursor;

      drag.target: delegate;
      drag.axis: Drag.YAxis;
      drag.minimumY: 0;
      drag.maximumY: list.implicitHeight - height;

      z: drag.active ? 1 : 0;

      function moveItem(arr, index, targetIndex) {
        let result = [...arr];
        if (targetIndex >= arr.length || targetIndex < 0) {
          console.error("moveItem: Failed to move: target index out of range")
          return arr;
        }
        result.splice(targetIndex, 0, result.splice(index, 1)[0]);
        return result;
      }

      property double originalY: y;
      onPressed: originalY = y;

      onReleased: {
        const deltaY = y - originalY;
        const swapDistance = Math.round(deltaY / (height+list.spacing));

        let targetIndex = index+swapDistance;
        if (targetIndex < 0) targetIndex = 0;
        if (targetIndex > list.model.values.length-1) targetIndex = list.model.values.length-1;

        if (targetIndex !== index) {
          root.currentVal.values = moveItem(root.currentVal.values, index, targetIndex);
        } else {
          y = originalY;
        }
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

          anchors {
            left: parent.left;
            right: parent.right;
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
            text: root.options[delegate.modelData].title;
            Layout.fillWidth: true;
            color: Globals.colours.fg;
            font {
              family: Globals.vars.fontFamily;
              pixelSize: Globals.vars.smallHeadingFontSize;
            }
            maximumLineCount: 1;
            elide: Text.ElideRight;
          }

          Item { Layout.fillWidth: true }

          Button {
            id: removeBtn;

            icon: "delete-symbolic";
            iconSize: Globals.vars.moduleIconSize;
            labelColour: Globals.colours.red;
            bgPress: Globals.colours.red;

            onClicked: root.currentVal.values.splice(delegate.index, 1);
          }
        }
      }
    }
  }
}

