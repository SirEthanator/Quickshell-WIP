pragma ComponentBehavior: Bound

import qs.singletons
import qs.components
import qs.widgets.settings // For LSP
import qs.animations as Anims;
import QtQuick;

Input {
  id: root;

  required property string page;
  required property string propName;
  property bool allowEmpty: false;

  readonly property var defaultvalueParser: (text) => text;
  property var valueParser: defaultvalueParser;

  QtObject {
    id: internal;
    property bool completed: false;
  }

  readonly property bool completed: internal.completed;
  Component.onCompleted: {
    internal.completed = true;
  }

  property var currentVal: Controller.getVal(page, propName);

  width: 200;
  bg: Globals.colours.bg;
  borderColor: field.acceptableInput ? Globals.colours.outline : Globals.colours.red;

  Anims.ColourTransition on borderColor {}

  field: InputField {
    text: root.currentVal;
    placeholderText: "Enter a value";

    onTextChanged: {
      if (root.completed) {
        if ((!!text || root.allowEmpty) && acceptableInput) {
          const value = (typeof root.valueParser === "function") ? root.valueParser(text) : root.defaultvalueParser(text);
          Controller.changeVal(root.page, root.propName, value);
        }
        else
          Controller.changeVal(root.page, root.propName, Conf[root.page][root.propName]);
      }
    }
  }
}

