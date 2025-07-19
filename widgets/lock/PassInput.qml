pragma ComponentBehavior: Bound

import qs
import qs.components
import QtQuick;
import QtQuick.Layouts;

Input {
  id: root;
  required property Pam pam;

  Layout.fillWidth: true;

  field: InputField {
    placeholderText: "Enter your password";

    echoMode: TextInput.Password;
    inputMethodHints: Qt.ImhSensitiveData;

    onAccepted: root.pam.attemptUnlock();
    onTextChanged: root.pam.password = text;

    readOnly: root.pam.active;
    opacity: root.pam.active ? Globals.vars.disabledOpacity : 1;

    focus: true;
    onFocusChanged: { if (!focus) focus = true }
    onActiveFocusChanged: { if (!activeFocus) forceActiveFocus() }
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

    disabled: root.pam.active;

    onClicked: root.pam.attemptUnlock();
  }
}

