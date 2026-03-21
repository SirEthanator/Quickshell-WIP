import qs.components
import QtQuick;
import QtQuick.Layouts;

PasswordInput {
  id: root;
  required property Pam pam;

  Layout.fillWidth: true;

  disabled: pam.active;
  forceFocus: true;

  onSubmit: (text) => {
    root.pam.password = text;
    root.pam.attemptUnlock();
  }
}

