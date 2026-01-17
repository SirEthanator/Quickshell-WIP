import qs.components
import qs.widgets.polkit  // For LSP
import QtQuick;
import QtQuick.Layouts;

PasswordInput {
  id: root;

  required property Polkit polkit;

  Layout.fillWidth: true;

  disabled: polkit.isAuthenticating;

  onSubmit: (text) => {
    polkit.submit(text);
  }
}

