pragma ComponentBehavior: Bound

import "root:/";
import "root:/components";
import QtQuick;
import QtQuick.Layouts;

ColumnLayout {
  id: root;
  anchors.centerIn: parent;
  required property Pam pam;

  property alias text: input.field.text;

  Input {
    id: input;
    focus: true;
    width: 600;
    Layout.alignment: Qt.AlignHCenter;

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

      radiusValue: input.radius - Globals.vars.outlineSize;
      trRadius: true; brRadius: true;
      bg: Globals.colours.bgLight;

      disabled: root.pam.active;

      onClicked: root.pam.attemptUnlock();
    }
  }

  Text {
    text: root.pam.state === "authenticating"
      ? "Authenticating..."
      : root.pam.state === "failed" || root.pam.state === "error"
        ? "Authentication failed."
        : root.pam.state === "maxTries"
          ? "Maximum attempts reached."
          : ""
    visible: text !== "";
    font {
      family: Globals.vars.fontFamily;
      pixelSize: Globals.vars.mainFontSize;
    }
    color: root.pam.state === "failed" || root.pam.state === "error"
        ? Globals.colours.red
        : root.pam.state === "maxTries"
          ? Globals.colours.red
          : Globals.colours.grey;
  }
}

