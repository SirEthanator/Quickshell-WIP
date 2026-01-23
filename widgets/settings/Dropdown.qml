pragma ComponentBehavior: Bound

import qs.singletons
import qs.components
import qs.widgets.settings // For LSP
import qs.animations as Anims;
import QtQuick;

Rectangle {
  id: root;
  required property var options;
  required property string page;
  required property string propName;

  property int currentIndex: Object.keys(options).indexOf(Controller.getVal(page, propName));
  property string displayText: model[currentIndex].title;

  property int padding: Consts.paddingButton;

  readonly property bool popupOpen: popup.visible;

  readonly property bool completed: internal.completed;
  QtObject {
    id: internal;
    property bool completed: false;
  }
  Component.onCompleted: internal.completed = true;

  color: mouse.containsMouse && !popup.visible ? Globals.colours.bgHover : Globals.colours.bg;
  // Radius set by border

  Anims.ColourTransition on color {}

  width: 200;
  height: text.height + padding*2;

  Border {
    bottomBorder: !popup.visible;
    bottomLeftRadius: !popup.visible ? Consts.br : 0; bottomRightRadius: bottomLeftRadius;
    setParentRadius: true;
  }

  MouseArea {
    id: mouse;
    anchors.fill: parent;
    onClicked: popup.toggle();
    hoverEnabled: true;
  }

  Text {
    id: text;
    text: root.displayText;
    font {
      family: Consts.fontFamily;
      pixelSize: Consts.mainFontSize;
    }
    color: Globals.colours.fg;
    anchors.verticalCenter: parent.verticalCenter;
    anchors.left: parent.left;
    anchors.leftMargin: root.padding;
  }

  Icon {
    icon: "expand-symbolic";
    color: Globals.colours.fg;
    rotation: popup.visible ? 180 : 0;
    size: text.height;
    anchors.verticalCenter: root.verticalCenter;
    anchors.right: root.right;
    anchors.rightMargin: root.padding;
  }

  property var model: {
    let result = [];
    for (const key in options) {
      result.push(Object.assign({ key: key }, options[key]));
    }
    return result;
  }

  onCurrentIndexChanged: {
    if (completed) {
      Controller.changeVal(page, propName, model[currentIndex].key);
    }
  }

  Rectangle {
    id: popup;
    width: root.width;
    height: items.contentHeight;
    anchors.top: root.bottom;

    visible: false;

    color: Globals.colours.bg;
    // Radius set by border

    Border {
      topBorder: false;
      setParentRadius: true;
      topLeftRadius: 0; topRightRadius: 0;
    }

    function close() { visible = false }
    function open() { visible = true; forceActiveFocus() }
    function toggle() { visible = !visible; if (visible) forceActiveFocus() }

    onActiveFocusChanged: {
      if (!activeFocus) close();
    }

    ListView {
      id: items;
      anchors.fill: parent;
      // No padding needed, the buttons have their own.

      clip: true;
      interactive: false;
      boundsBehavior: Flickable.StopAtBounds;

      model: root.model;
      delegate: Button {
        required property var modelData;
        required property int index;

        radiusValue: popup.bottomLeftRadius;  // Either of the bottom radii will work, not top because they are 0
        allRadius: true;

        label: modelData.title;
        centreLabel: false;
        height: implicitHeight;
        anchors.right: parent.right;
        anchors.left: parent.left;

        onClicked: {
          root.currentIndex = index;
          popup.close();
        }
      }
    }
  }
}

