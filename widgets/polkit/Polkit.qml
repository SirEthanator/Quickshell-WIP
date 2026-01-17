import qs.widgets.sidebar as Sidebar
import Quickshell.Services.Polkit
import QtQuick;

Item {
  id: root;

  property bool isAuthenticating: false;

  PolkitAgent {
    id: polkitAgent;

    onIsActiveChanged: {
      if (isActive) {
        Sidebar.Controller.activate("polkit");
      }
    }
  }

  readonly property PolkitAgent agent: polkitAgent;

  readonly property alias flow: polkitAgent.flow;

  function submit(text: string) {
    isAuthenticating = true;
    polkitAgent.flow.submit(text);
  }

  Connections {
    target: polkitAgent.flow;

    function onFailedChanged() {
      root.isAuthenticating = false;
    }
    function onIsSuccessfulChanged() {
      root.isAuthenticating = false;
    }
  }
}
