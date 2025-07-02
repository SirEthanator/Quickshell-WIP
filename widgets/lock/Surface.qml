import "root:/";
import "root:/components";
import Quickshell.Wayland;
import Quickshell.Services.Pam;
import QtQuick;
import QtQuick.Layouts;

WlSessionLockSurface {
  id: root;

  required property WlSessionLock lock;
  property string password;
  property string pamState;

  onPasswordChanged: {
    if (password !== input.field.text) input.field.text = password;
  }

  color: Globals.colours.bg;

  function attemptUnlock() {
    if (!pam.active)
      pam.start();
  }

  PamContext {
    id: pam;

    // responseRequired is set to true on pam.start()
    onResponseRequiredChanged: {
      if (responseRequired) {
        root.pamState = "authenticating";
        respond(root.password);
        root.password = "";
      }
    }

    onCompleted: result => {
      if (result === PamResult.Success) {
        root.lock.unlock();
      } else if (result === PamResult.Failed) {
        root.pamState = "failed"
      } else if (result === PamResult.MaxTries) {
        root.pamState = "maxTries"
      } else if (result === PamResult.Error) {
        root.pamState = "error"
      }
    }
  }

  ColumnLayout {
    id: column;
    anchors.centerIn: parent;

    Input {
      id: input;
      focus: true;
      width: 600;
      Layout.alignment: Qt.AlignHCenter;

      field: InputField {
        placeholderText: "Enter your password";

        echoMode: TextInput.Password;
        inputMethodHints: Qt.ImhSensitiveData;

        onAccepted: root.attemptUnlock();
        onTextChanged: root.password = text;
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

        disabled: pam.active;

        onClicked: root.attemptUnlock();
      }
    }

    Text {
      text: root.pamState === "authenticating"
        ? "Authenticating..."
        : root.pamState === "failed" || root.pamState === "error"
          ? "Authentication failed."
          : root.pamState === "maxTries"
            ? "Maximum attempts reached."
            : ""
      visible: text !== "";
      font {
        family: Globals.vars.fontFamily;
        pixelSize: Globals.vars.mainFontSize;
      }
      color: root.pamState === "failed" || root.pamState === "error"
          ? Globals.colours.red
          : root.pamState === "maxTries"
            ? Globals.colours.red
            : Globals.colours.grey;
    }
  }
}

