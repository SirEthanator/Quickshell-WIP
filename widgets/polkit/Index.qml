pragma ComponentBehavior: Bound

import qs.singletons
import qs.widgets.polkit  // For LSP
import qs.widgets.sidebar as Sidebar;
import qs.components
import Quickshell;
import QtQuick;
import QtQuick.Layouts;

Item {
  id: root;

  function deactivate() {
    Sidebar.Controller.deactivate("polkit");
  }

  required property Polkit polkit;
  readonly property bool isCurrent: Sidebar.Controller.current === "polkit";

  anchors.fill: parent;

  Keys.onPressed: (event) => {
    if (!Sidebar.Controller.sidebarOpen || !root.isCurrent) return;
    const key = event.key;

    if (key === Qt.Key_Escape) {
      root.polkit.flow.cancelAuthenticationRequest();
      root.deactivate();
    }
  }

  onIsCurrentChanged: {
    if (isCurrent) {
      passInput.forceActiveFocus();
    }
  }

  Connections {
    target: root.polkit.flow;

    function onIsCompletedChanged() {
      if (target.isCompleted) root.deactivate();
    }

    function onIsCancelledChanged() {
      if (target.isCancelled) root.deactivate();
    }
  }

  Item {
    id: content;
    anchors.fill: parent;

    ColumnLayout {
      id: mainColumn;
      anchors.centerIn: parent;
      width: parent.width;
      spacing: Consts.paddingWindow * 2;

      RowLayout {
        spacing: Consts.paddingWindow;
        Layout.fillWidth: true;

        Icon {
          size: 64;
          icon: root.polkit.flow.iconName;
          fallback: "gtk-dialog-authentication";
          isMask: false;
        }

        ColumnLayout {
          spacing: Consts.marginCard;

          Text {
            Layout.fillWidth: true;
            text: root.polkit.flow.message;
            color: Globals.colours.fg;
            font {
              family: Consts.fontFamily;
              pixelSize: Consts.smallHeadingFontSize;
            }
            wrapMode: Text.Wrap;
          }

          Text {
            text: "An application is attempting to perform an action requiring elevated permissions. Authentication is required.";
            Layout.fillWidth: true;
            color: Globals.colours.grey;
            font {
              family: Consts.fontFamily;
              pixelSize: Consts.mainFontSize;
            }
            wrapMode: Text.Wrap;
          }

        }
      }

      PassInput {
        id: passInput;
        polkit: root.polkit;
      }
    }

    Button {
      anchors {
        right: parent.right;
        top: mainColumn.bottom;
        topMargin: Consts.marginCard;
      }

      label: "Cancel";

      allRadius: true;
      bg: Globals.colours.bgLight;

      onClicked: {
        root.polkit.flow.cancelAuthenticationRequest();
        root.deactivate();
      }
    }

    Status { polkit: root.polkit }
  }
}
