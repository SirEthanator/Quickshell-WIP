pragma ComponentBehavior: Bound

import "root:/";
import "root:/components";
import QtQuick;

Input {
  id: root;

  required property var controller;
  required property string page;
  required property string propName;
  property int max;
  property int min;

  property bool completed: false;
  Component.onCompleted: {
    completed = true;
  }

  property int currentVal: controller.getVal(page, propName);

  width: 200;
  bg: Globals.colours.bg;

  field: InputField {
    text: root.currentVal;
    placeholderText: "placeholder";
    focusPolicy: Qt.ClickFocus;
    validator: IntValidator {
      bottom: root.min ?? undefined;
      top: root.max ?? undefined;
    }

    onTextChanged: {
      if (!!text && root.completed) root.controller.changeVal(root.page, root.propName, parseInt(text));
    }
  }
}

