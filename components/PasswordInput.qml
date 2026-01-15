pragma ComponentBehavior: Bound

import qs.singletons
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
    opacity: root.disabled ? Consts.disabledOpacity : 1;

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
    iconSize: Consts.moduleIconSize;

    Layout.fillHeight: true;

    radiusValue: root.radius - Consts.outlineSize;
    trRadius: true; brRadius: true;
    bg: Globals.colours.bgLight;

    disabled: root.disabled;

    onClicked: root.submit(root.field.text);
  }
}

