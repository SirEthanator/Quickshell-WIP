import Quickshell.Services.Polkit;
import QtQuick;

PolkitAgent {
  id: root;
  property bool isAuthenticating: false;

  function submit(text: string) {
    // isAuthenticating is set back to false using a
    // Connections component in Index.qml
    isAuthenticating = true;
    flow.submit(text);
  }
}

