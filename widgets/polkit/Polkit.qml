pragma Singleton

import Quickshell
import Quickshell.Services.Polkit;
import QtQuick;

Singleton {
  id: root;

  property bool isAuthenticating: false;

  readonly property PolkitAgent agent: PolkitAgent { id: agent }
  readonly property alias flow: agent.flow;

  function submit(text: string) {
    isAuthenticating = true;
    agent.flow.submit(text);
  }

  Connections {
    target: root.agent.flow;

    function onFailedChanged() {
      root.isAuthenticating = false;
    }
    function onIsSuccessfulChanged() {
      root.isAuthenticating = false;
    }
  }
}

