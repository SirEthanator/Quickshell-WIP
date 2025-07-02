pragma ComponentBehavior: Bound

import "root:/";
import "root:/components";
import QtQuick;
import QtQuick.Layouts;

Input {
  id: root;
  required property Pam pam;

  focus: true;
  Layout.fillWidth: true;

  field: InputField {
    placeholderText: "Enter your password";

    echoMode: TextInput.Password;
    inputMethodHints: Qt.ImhSensitiveData;

    onAccepted: root.pam.attemptUnlock();
    onTextChanged: root.pam.password = text;
  }

  rightPadding: false;

  Button {
    id: confirmBtn;
    label: "checkmark-symbolic";
    icon: true;

    autoImplicitWidth: true;
    Layout.fillHeight: true;

    radiusValue: root.radius - Globals.vars.outlineSize;
    trRadius: true; brRadius: true;
    bg: Globals.colours.bgLight;

    disabled: root.pam.active;

    onClicked: root.pam.attemptUnlock();
  }
}

