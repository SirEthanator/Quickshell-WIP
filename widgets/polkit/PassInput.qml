import qs.components
import QtQuick;
import QtQuick.Layouts;

PasswordInput {
  id: root;

  Layout.fillWidth: true;

  forceFocus: true;
  disabled: Polkit.isAuthenticating;

  onSubmit: (text) => {
    Polkit.submit(text);
  }
}

