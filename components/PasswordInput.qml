pragma ComponentBehavior: Bound

import qs
import qs.components
import QtQuick;
import QtQuick.Layouts;

Input {
  id: root;

  signal submit(text: string);
  signal change(text: string);

  property bool disabled: false;
  property bool forceFocus: false;

  field: InputField {
    placeholderText: "Enter your password";

    echoMode: TextInput.Password;
    inputMethodHints: Qt.ImhSensitiveData;

    onAccepted: root.submit(text);
    onTextChanged: root.change(text);

    readOnly: root.disabled;
    opacity: root.disabled ? Globals.vars.disabledOpacity : 1;

    focus: true;
    onFocusChanged: { if (root.forceFocus && !focus) focus = true }
    onActiveFocusChanged: { if (root.forceFocus && !activeFocus) forceActiveFocus() }
  }

  rightPadding: false;
  topPadding: false;
  bottomPadding: false;

  Button {
    id: confirmBtn;
    icon: "checkmark-symbolic";
    iconSize: Globals.vars.moduleIconSize;

    Layout.fillHeight: true;

    radiusValue: root.radius - Globals.vars.outlineSize;
    trRadius: true; brRadius: true;
    bg: Globals.colours.bgLight;

    disabled: root.disabled;

    onClicked: root.submit(root.field.text);
  }
}

