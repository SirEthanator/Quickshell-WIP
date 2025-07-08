import "root:/";
import "root:/components";
import QtQuick;

Input {
  id: root;

  required property var controller;
  required property string page;
  required property string propName;

  property bool completed: false;
  Component.onCompleted: {
    completed = true;
  }

  property string currentVal: controller.getVal(page, propName);

  width: 200;

  bg: Globals.colours.bg;

  field: InputField {
    text: root.currentVal;
    placeholderText: "PLACEHOLDER";

    onTextChanged: {
      if (root.completed) root.controller.changeVal(root.page, root.propName, text);
    }
  }
}

