import qs.components
import QtQuick;
import QtQuick.Layouts;

PasswordInput {
  id: root;
  required property Polkit polkit;

  Layout.fillWidth: true;

  forceFocus: true;
  disabled: polkit.isAuthenticating;

  onSubmit: (text) => {
    root.polkit.submit(text);
  }
}

