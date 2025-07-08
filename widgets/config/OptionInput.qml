pragma ComponentBehavior: Bound

import "root:/";
import "root:/components";
import "root:/animations" as Anims;
import QtQuick;

Input {
  id: root;

  required property var controller;
  required property string page;
  required property string propName;
  property bool allowEmpty: false;

  QtObject {
    id: internal;
    property bool completed: false;
  }

  readonly property bool completed: internal.completed;
  Component.onCompleted: {
    internal.completed = true;
  }

  property var currentVal: controller.getVal(page, propName);

  width: 200;
  bg: Globals.colours.bg;
  borderColor: field.acceptableInput ? Globals.colours.outline : Globals.colours.red;

  Anims.ColourTransition on borderColor {}

  field: InputField {
    text: root.currentVal;
    placeholderText: "Enter a value";

    onTextChanged: {
      if (root.completed) {
        if ((!!text || root.allowEmpty) && acceptableInput)
          root.controller.changeVal(root.page, root.propName, text);
        else
          root.controller.changeVal(root.page, root.propName, Globals.conf[root.page][root.propName]);
      }
    }
  }
}

